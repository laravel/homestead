<?php namespace Laravel\Homestead;

use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class InitCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('init')
			->setDescription('Create a stub Homestead.yaml file')
			->addOption('local', 'l', InputOption::VALUE_NONE, 'Initialize homestead in the current working directory');
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
		if ($input->getOption('local')) {
			$this->initLocal($input, $output);
		} else {
			$this->initGlobal($input, $output);
		}

	}

	protected function initLocal(InputInterface $input, OutputInterface $output)
	{
		if (is_dir(homestead_local_path())) {
			throw new \InvalidArgumentException("Homestead has already been initialized.");
		}

		mkdir(homestead_local_path());
		mkdir(homestead_local_path() . '/scripts');
		mkdir(homestead_local_path() . '/homestead');

		copy(__DIR__ . '/stubs/local/Homestead.yaml', homestead_local_path() . '/Homestead.yaml');
		copy(__DIR__ . '/stubs/common/after.sh', homestead_local_path() . '/scripts/after.sh');
		copy(__DIR__ . '/stubs/common/aliases', homestead_local_path() . '/scripts/aliases');

		copy(__DIR__ . '/stubs/local/Vagrantfile', homestead_local_path() . '/Vagrantfile');

		copy(__DIR__ . '/../scripts/serve.sh', homestead_local_path() . '/homestead/serve.sh');
		copy(__DIR__ . '/../scripts/blackfire.sh', homestead_local_path() . '/homestead/blackfire.sh');
		copy(__DIR__ . '/../scripts/create-mysql.sh', homestead_local_path() . '/homestead/create-mysql.sh');
		copy(__DIR__ . '/../scripts/create-postgres.sh', homestead_local_path() . '/homestead/create-postgres.sh');
		copy(__DIR__ . '/../scripts/serve.sh', homestead_local_path() . '/homestead/serve.sh');
		copy(__DIR__ . '/../scripts/serve-hhvm.sh', homestead_local_path() . '/homestead/serve-hhvm.sh');

		copy(__DIR__ . '/../scripts/serve-hhvm.sh', homestead_local_path() . '/homestead/serve-hhvm.sh');


		copy(__DIR__ . '/../scripts/local-homestead.rb', homestead_local_path() . '/homestead/homestead.rb');

		$output->writeln('<comment>Creating Homestead.yaml file...</comment> <info>✔</info>');
		$output->writeln('<comment>Homestead.yaml file created at:</comment> '.homestead_local_path().'/Homestead.yaml');
	}

	protected function initGlobal(InputInterface $input, OutputInterface $output)
	{
		if (is_dir(homestead_path())) {
			throw new \InvalidArgumentException("Homestead has already been initialized.");
		}

		mkdir(homestead_path());

		copy(__DIR__ . '/stubs/global/Homestead.yaml', homestead_path() . '/Homestead.yaml');
		copy(__DIR__ . '/stubs/common/after.sh', homestead_path() . '/after.sh');
		copy(__DIR__ . '/stubs/common/aliases', homestead_path() . '/aliases');


		$output->writeln('<comment>Creating Homestead.yaml file...</comment> <info>✔</info>');
		$output->writeln('<comment>Homestead.yaml file created at:</comment> '.homestead_path().'/Homestead.yaml');
	}

}
