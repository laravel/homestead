<?php
namespace Laravel\Homestead;

use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Helper\DialogHelper;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Process\Process;

class HostCommand extends Command
{
    /**
     * @var string  The ip to map.
     */
    private $ip;

    /**
     * @var string The hostname to map.
     */
    private $hostName;

    /**
     * @var string The absolute path of the hosts file.
     */
    private $hostFile;

    /**
     * @var DialogHelper A dialog helper for the command.
     */
    protected $dialog;

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->setName('hosts')
            ->setDescription('Adds a homestead entry to the hosts file.')
            ->addArgument(
                'ip',
                InputArgument::REQUIRED,
                'Enter the IP address to map to'
            )
            ->addArgument(
                'hostname',
                InputArgument::REQUIRED,
                'Enter the hostname to map'
            );
    }

    /**
     * Execute the command.
     *
     * @param  \Symfony\Component\Console\Input\InputInterface $input
     * @param  \Symfony\Component\Console\Output\OutputInterface $output
     * @return void
     */
    public function execute(InputInterface $input, OutputInterface $output)
    {
        $this->dialog = $this->getHelper('dialog');
        $this->ip = $input->getArgument('ip');
        $this->hostName = $input->getArgument('hostname');
        $this->hostFile = $this->getHostsFile();

        if ($this->hostFile === false) {
            $output->writeln('We could not find your host file.');

            return;
        }


        if ($this->dialog->askConfirmation($output,
            "Mapping '" . $this->ip . "' to '" . $this->hostName . "'. Is that okay? (Y/n) ")
        ) {
            $output->writeln('Okay! Will now write to hosts file...');

            $command = $this->getCommand();

            if ($command === false) {
                $output->writeln('We could not find the correct command.');

                return;
            }

            $writeProcess = new Process($command, realpath(__DIR__ . '/../'),
                array_merge($_SERVER, $_ENV), null, null);

            $writeProcess->run();

            $output->writeLn('Added to your hosts! Have fun developing. :-)');
        }
    }

    /**
     * Find the correct host file depending on the OS.
     *
     * @return string
     */
    protected function getHostsFile()
    {
        if (strpos(strtoupper(PHP_OS), 'WIN') === 0) {
            return '%systemroot%\system32\drivers\etc';
        } elseif (strpos(strtoupper(PHP_OS), 'DARWIN') === 0) {
            return '/etc/hosts';
        } elseif (strpos(strtoupper(PHP_OS), 'LINUX') === 0) {
            return '/etc/hosts';
        } else {
            return false;
        }
    }

    /**
     * Get the command to execute.
     *
     * @return bool|string
     */
    protected function getCommand()
    {
        if (strpos(strtoupper(PHP_OS), 'WIN') === 0) {
            return 'echo "' . $this->ip . ' ' . $this->hostName . '" >> "' . $this->hostFile . '"';
        } elseif (strpos(strtoupper(PHP_OS), 'DARWIN') === 0 || strpos(strtoupper(PHP_OS), 'LINUX') === 0
        ) {
            return 'echo "' . $this->ip . ' ' . $this->hostName . '" >> "' . $this->hostFile . '"';
        } else {
            return false;
        }
    }
}