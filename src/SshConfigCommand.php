<?php namespace Laravel\Homestead;

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

        passthru($this->setEnvironmentCommand() . ' vagrant ssh-config');
    }

    protected function setEnvironmentCommand()
    {
        if ($this->isWindows()) {
            return 'SET VAGRANT_DOTFILE_PATH='.$_ENV['VAGRANT_DOTFILE_PATH'].' &&';
        }

        return 'VAGRANT_DOTFILE_PATH="'.$_ENV['VAGRANT_DOTFILE_PATH'].'"';
    }

    protected function isWindows()
    {
        return strpos(strtoupper(PHP_OS), 'WIN') === 0;
    }
}
