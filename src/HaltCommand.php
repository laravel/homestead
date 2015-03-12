<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class HaltCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('halt')
                  ->setDescription('Halt the Homestead machine');
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
		$path = realpath(homestead_local_path()) ?: realpath(__DIR__.'/../');

		$process = new Process('vagrant halt', $path, array_merge($_SERVER, $_ENV), null, null);

		$process->run(function($type, $line) use ($output)
		{
			$output->write($line);
		});
	}

}
