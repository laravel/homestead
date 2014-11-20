<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class EditCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('edit')
                  ->setDescription('Edit the Homestead.yaml file');
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
		if (defined('PHP_WINDOWS_VERSION_BUILD'))
		{
			$command = 'start '.getenv('AppData').'/Homestead/Homstead.yaml';
		}
		else
		{
			$command = 'open ~/.homestead/Homestead.yaml';
		}

		$process = new Process($command, realpath(__DIR__.'/../'), null, null, null);

		$process->run(function($type, $line) use ($output)
		{
			$output->write($line);
		});
	}

}
