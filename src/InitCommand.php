<?php namespace Laravel\Homestead;

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
			->addArgument('name');
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
		$envName = $input->getArgument('name');
		if (is_null($envName))
		{
			$envName = 'Homestead';
		}
		$configureFilePath = homestead_path()."/{$envName}.yaml";

		if (file_exists($configureFilePath))
		{
			throw new \InvalidArgumentException("Homestead has already been initialized.");
		}

		if (!is_dir(homestead_path()))
		{
			mkdir(homestead_path());
		}

		copy(__DIR__.'/stubs/Homestead.yaml', $configureFilePath);
		copy(__DIR__.'/stubs/after.sh', homestead_path().'/after.sh');
		copy(__DIR__.'/stubs/aliases', homestead_path().'/aliases');

		$output->writeln('<comment>Creating '.$envName.'.yaml file...</comment> <info>✔</info>');
		$output->writeln('<comment>Homestead.yaml file created at:</comment> '.homestead_path().'/'.$envName.'.yaml');
	}

}
