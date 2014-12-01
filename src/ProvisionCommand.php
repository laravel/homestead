<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ProvisionCommand extends Command {

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->setName('provision')
            ->setDescription('Provision the Homestead machine');
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
	    $process = new Process('vagrant provision', realpath(__DIR__.'/../'), null, null, null);
	    
	    $process->run(function($type, $line) use ($output)
	    {
	        $output->write($line);
	    });
	 }
}
