<?php namespace Laravel\Homestead;

use Symfony\Component\Process\ProcessBuilder;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ShareCommand extends Command {

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
	 * @return void
	 */
	public function execute(InputInterface $input, OutputInterface $output)
	{
		$arguments = array('share');
	
		// Set share name
		$name = $input->getOption('name');
		if ($name)
		{
			$arguments[] = '--name';
			$arguments[] = $name;
		}
		else
		{
			$arguments[] = '--name';
			$arguments[] = 'share';
		}
		
		// Pass optional custom domain
		$domain = $input->getOption('domain');
		if ($domain)
		{
			$arguments[] = '--domain';
			$arguments[] = $domain;
		}
		
		// Build process and execute
		$builder = new ProcessBuilder($arguments);
		$builder->setPrefix('vagrant');
		$builder->setTimeout(null);
		
		$builder->addEnvironmentVariables($_ENV);
		$builder->setWorkingDirectory(realpath(__DIR__.'/../'));

		$builder->getProcess()->run(function($type, $line) use ($output)
		{
			$output->write($line);
		});
	}

}
