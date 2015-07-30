<?php namespace Laravel\Homestead;

use Laravel\Homestead\Support\Portability;
use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SshConfigCommand extends Command
{
    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->setName('ssh-config')
                  ->setDescription('Outputs OpenSSH valid configuration to connect to Homestead');
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
        chdir(__DIR__.'/../');

        passthru(Portability::setEnvironmentCommand() . ' vagrant ssh-config');
    }
}
