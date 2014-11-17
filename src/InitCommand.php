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
                  ->setDescription('Create a stub Homestead.yaml file');
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
		$directory = $_SERVER['HOME'].'/.homestead';

		if (is_dir($directory))
		{
			throw new \InvalidArgumentException("Homestead has already been initialized.");
		}

		mkdir($directory);

		copy(__DIR__.'/stubs/Homestead.yaml', $directory.'/Homestead.yaml');
		copy(__DIR__.'/stubs/after.sh', $directory.'/after.sh');
		copy(__DIR__.'/stubs/aliases', $directory.'/aliases');

		file_put_contents(
			__DIR__.'/../var/config.json',
			json_encode(['directory' => realpath($directory)], JSON_PRETTY_PRINT)
		);

		$output->writeln('<comment>Creating Homestead.yaml file...</comment> <info>✔</info>');
		$output->writeln('<comment>Homestead.yaml file created at:</comment> '.$directory.'/Homestead.yaml');
	}

}
