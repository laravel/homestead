<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class DirectoryCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('directory')
                  	->setDescription('Set the Homestead configuration directory')
					->addArgument('directory', InputArgument::REQUIRED, 'The directory containing your Homestead.yaml file.');
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
		$path = realpath($input->getArgument('directory'));

		if ($path === false)
		{
			throw new \InvalidArgumentException("Directory does not exist.");
		}

		file_put_contents(
			__DIR__.'/../var/config.json',
			json_encode(['directory' => $path], JSON_PRETTY_PRINT)
		);

		$output->writeln('<comment>Setting Homestead directory...</comment> <info>✔</info>');
	}

}
