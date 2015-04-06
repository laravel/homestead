<?php namespace Laravel\Homestead;

use Symfony\Component\Console\Helper\ProgressBar;
use Symfony\Component\Console\Helper\Table;
use Symfony\Component\Console\Question\ConfirmationQuestion;
use Symfony\Component\Process\Exception\RuntimeException;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\ProcessBuilder;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Yaml\Yaml;

class ShareCommand extends Command
{
	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('share')
			->setDescription('Share the Homestead machine using "vagrant share"')
			->addOption('name', null, InputOption::VALUE_REQUIRED, 'Change the default name ("share") for the share')
			->addOption('domain', null, InputOption::VALUE_REQUIRED, 'Set a custom domain name for the share');
	}

	/**
	 * Execute the command.
	 *
	 * @param  \Symfony\Component\Console\Input\InputInterface  $input
	 * @param  \Symfony\Component\Console\Output\OutputInterface  $output
	 * @return int
	 */
	public function execute(InputInterface $input, OutputInterface $output)
	{
		$config = Yaml::Parse(file_get_contents(homestead_path() . '/Homestead.yaml'));

		$questionHelper = $this->getHelper('question');

		/*
		 * Get a list of sites enabled for sharing
		 */
		$sites = array();
		foreach ($config['sites'] as $site)
		{
			if (isset($site['share']) && $site['share'])
			{
				// This will contain the hostname used for sharing
				$site['hostname'] = '';

				$sites[$site['map']] = $site;
			}
		}

		ksort($sites);

		if (sizeof($sites) == 0)
		{
			$output->writeln('<error>Could not find any sites enabled for sharing in your Homestead.yaml</error>');
			$output->writeln('  1) Run "homestead edit" to edit your Homestead.yaml');
			$output->writeln('  2) Add "share: true" to the sites you would like to share with the outside world');
			$output->writeln("  3) Run this command again\n");

			return 1;
		}

		// Check for > 5 sites since each site requires an additional call to serve.sh
		if (sizeof($sites) > 5)
		{
			$output->writeln('You have more than 5 sites enabled for sharing. Are you sure you wish to proceed?');

			$question = new ConfirmationQuestion('Provisioning might take a while. [y,n] ', true);
			if (!$questionHelper->ask($input, $output, $question))
			{
				return 0;
			}
		}

		$output->writeln('<info>Starting Vagrant share session, this may take a moment...</info>');

		$arguments = array('share');

		// Set share name
		if (isset($config['share']['name']) && $config['share']['name'])
		{
			$arguments[] = '--name';
			$arguments[] = $config['share']['name'];
		}
		else
		{
			$arguments[] = '--name';
			$arguments[] = 'share';
		}

		// Pass optional custom domain
		if (isset($config['share']['domain']) && $config['share']['domain'])
		{
			$arguments[] = '--domain';
			$arguments[] = $config['share']['domain'];
		}

		// Build "share" process and execute
		$builder = new ProcessBuilder($arguments);
		$builder->setPrefix('vagrant');
		$builder->setTimeout(null);

		$builder->addEnvironmentVariables($_ENV);
		$builder->setWorkingDirectory(realpath(__DIR__ . '/../'));

		$share = $builder->getProcess();
		$share->start();

		$endpoint = null;

		/*
		 * Wait till the process has completed and set up the addition sites for hosting under the sharing domain
		 */
		while ($share->isRunning())
		{
			$output->write($share->getIncrementalOutput());
			if (strpos($share->getOutput(), '==> default: Your Vagrant Share is running!') !== false && preg_match('#URL: http://([a-z0-9\-\.]+)#i', $share->getOutput(), $result) > 0)
			{
				$endpoint = $result[1];

				// TODO: double-check CNAME for $endpoint

				$output->writeln('<info>Homestead machine shared successfully!</info>');
				$output->writeln(sprintf('Provisioning sites for sharing on <comment>*.%s</comment>', $endpoint));

				$progress = new ProgressBar($output, sizeof($sites));
				$progress->setFormat(' %current%/%max% [%bar%] %message%');
				$progress->setMessage('pending...');

				$progress->start();

				foreach ($sites as $site)
				{
					$hostname = $site['map'];
					if (isset($config['share']['replace']) && $config['share']['replace'])
					{
						$hostname = str_replace('.' . trim($config['share']['replace'], '.'), '.' . $endpoint, $hostname);
					}

					$sites[$site['map']]['hostname'] = $hostname;

					$progress->setMessage($hostname);

					// Invoke "serve[-hhvm].sh..."
					$script = (isset($site['hhvm']) && $site['hhvm']) ? 'serve-hhvm.sh' : 'serve.sh';
					$port = (isset($site['port']) && $site['port']) ? $site['port'] : 80;

					$builder = new ProcessBuilder(array('ssh', '--command', sprintf('sudo /vagrant/scripts/%s %s %s %d', $script, $hostname, $site['to'], $port)));
					$builder->setPrefix('vagrant');
					$builder->setTimeout(null);

					$builder->addEnvironmentVariables($_ENV);
					$builder->setWorkingDirectory(realpath(__DIR__.'/../'));

					$process = $builder->getProcess();
					$process->run();

					if (!$process->isSuccessful())
					{
						throw new RuntimeException(sprintf("Could not provision %s: %s", $hostname, $process->getErrorOutput()));
					}

					$progress->advance();
				}

				$progress->finish();

				/*
				 * Render hostnames table
				 */
				$output->writeln("\n");

				$table = new Table($output);
				$table->setHeaders(array('Hostname', 'Sharing URL'));

				foreach ($sites as $site)
				{
					$table->addRow(array($site['map'], 'http://' . $site['hostname']));
				}

				$table->render();
				$output->writeln('');

				$questionHelper->ask($input, $output, new ConfirmationQuestion('Sites are now available. Press <question>ENTER</question> to gracefully shut down the sharing session', true));

				break;
			}

			usleep(100000);
		}

		if (!$share->isRunning() && !$share->isSuccessful())
		{
			$output->writeln("<error>Could not share Homestead machine due to an error</error>\n" . $share->getErrorOutput());

			return 1;
		}

		/*
		 * Cleanup
		 */
		$output->writeln('Cleaning up sites, one moment...');

		$progress = new ProgressBar($output, sizeof($sites));
		$progress->setFormat(' %current%/%max% [%bar%] %message%');
		$progress->setMessage('pending...');

		$progress->start();

		foreach ($sites as $site)
		{
			$progress->setMessage($site['hostname']);

			$builder = new ProcessBuilder(array('ssh', '--command', sprintf('sudo /vagrant/scripts/stop-serve.sh %s', $site['hostname'])));
			$builder->setPrefix('vagrant');
			$builder->setTimeout(null);

			$builder->addEnvironmentVariables($_ENV);
			$builder->setWorkingDirectory(realpath(__DIR__.'/../'));

			$process = $builder->getProcess();
			$process->run();

			if (!$process->isSuccessful())
			{
				$output->writeln("\n");
				$output->writeln(sprintf('There was a problem while cleaning up <error>%s</error>. Some nginx configuration files might not have been deleted.', $site['hostname']));

				throw new RuntimeException($process->getErrorOutput());
			}

			$progress->advance();
		}

		$progress->finish();
		$output->writeln("\n");

		$share->stop();

		$output->writeln('<info>Sharing session terminated</info>');
	}
}
