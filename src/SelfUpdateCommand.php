<?php

namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SelfUpdateCommand extends Command
{
    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->setName('self-update')
             ->setAliases(['selfupdate'])
             ->setDescription('Update the Homestead to the latest version.')
             ->setHelp('The <info>%command.name%</info> command updates the Homestead to the latest available version.');
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
        $command = ' global update laravel/homestead';

        $process = new Process($this->findComposer().$command, null, null, null, null);

        $process->run(function ($type, $line) use ($output) {
            $output->write($line);
        });
    }

    /**
     * Get the composer command for the environment.
     *
     * @return string
     */
    protected function findComposer()
    {
        if (file_exists(getcwd().'/composer.phar')) {
            return '"'.PHP_BINARY.'" composer.phar';
        }

        return 'composer';
    }
}
