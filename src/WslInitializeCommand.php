<?php

namespace Laravel\Homestead;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class WslInitializeCommand extends Command
{
    /**
     * The base path of the Laravel installation.
     *
     * @var string
     */
    protected string $basePath;

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->basePath = getcwd();
        $this
            ->setName('wsl:init')
            ->setDescription('Run the WSL provisioning script');
    }

    /**
     * Execute the command.
     *
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return int
     */
    public function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeln('You can view the log by running tail -f wsl-init.log');
        $cert_cmd = "sudo bash {$this->basePath}/scripts/wsl.sh > wsl-init.log";
        shell_exec($cert_cmd);
        $output->writeln('Initialization Complete, please check wsl-init.log');

        return 0;
    }
}
