<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class UpCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('up')
                  ->setDescription('Start the Homestead machine')
				  ->addOption('provision', null, InputOption::VALUE_NONE, 'Run the provisioners on the box.');
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
		$command = 'vagrant up';

		if ($input->getOption('provision'))
			$command .= ' --provision';




		$path = realpath(homestead_local_path()) ?: realpath(__DIR__.'/../');

		$process = new Process($command, $path, array_merge($_SERVER, $_ENV), null, null);

		$process->run(function($type, $line) use ($output)
		{
			$output->write($line);
		});
	}

}
