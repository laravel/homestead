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
	 * Find the correct executable to run depending of the OS.
	 *
	 * @return string
	 */
	protected function executableName()
	{
		return strpos(strtoupper(PHP_OS), 'WIN') === 0 ? 'start' : 'open';
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
		$commandLine = $this->executableName() .' '.homestead_path().'/Homestead.yaml';
		$process = new Process($commandLine, realpath(__DIR__.'/../'), null, null, null);

		$process->run(function($type, $line) use ($output)
		{
			$output->write($line);
		});
	}

}
