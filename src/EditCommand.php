<?php

namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class EditCommand extends Command
{
    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this
            ->setName('edit')
            ->setDescription('Edit a Homestead file')
            ->addArgument('file', InputArgument::OPTIONAL, 'The file you wish to edit.');
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
        $file = 'Homestead.yaml';

        if ($input->getArgument('file') === 'aliases') {
            $file = 'aliases';
        }

        $command = $this->executable().' '.homestead_path().'/'.$file;

        $process = new Process($command, realpath(__DIR__.'/../'), array_merge($_SERVER, $_ENV), null, null);

        $process->run(function ($type, $line) use ($output) {
            $output->write($line);
        });
    }

    /**
     * Find the correct executable to run depending on the OS.
     *
     * @return string
     */
    protected function executable()
    {
        if (strpos(strtoupper(PHP_OS), 'WIN') === 0) {
            return 'start';
        } elseif (strpos(strtoupper(PHP_OS), 'DARWIN') === 0) {
            return 'open';
        }

        return 'xdg-open';
    }
}
