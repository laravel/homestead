<?php

namespace Laravel\Homestead;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class MakeCommand extends Command
{
    /**
     * The base path of the Laravel installation.
     *
     * @var string
     */
    protected $basePath;

    /**
     * The name of the project folder.
     *
     * @var string
     */
    protected $projectName;

    /**
     * Sluggified Project Name.
     *
     * @var string
     */
    protected $defaultName;

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->basePath = getcwd();
        $this->projectName = basename(getcwd());
        $this->defaultName = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $this->projectName)));

        $this
            ->setName('make')
            ->setDescription('Install Homestead into the current project')
            ->addOption('name', null, InputOption::VALUE_OPTIONAL, 'The name of the virtual machine.', $this->defaultName)
            ->addOption('hostname', null, InputOption::VALUE_OPTIONAL, 'The hostname of the virtual machine.', $this->defaultName)
            ->addOption('ip', null, InputOption::VALUE_OPTIONAL, 'The IP address of the virtual machine.')
            ->addOption('after', null, InputOption::VALUE_NONE, 'Determines if the after.sh file is created.')
            ->addOption('aliases', null, InputOption::VALUE_NONE, 'Determines if the aliases file is created.')
            ->addOption('example', null, InputOption::VALUE_NONE, 'Determines if a Homestead.yaml.example file is created.');
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
        if (! file_exists($this->basePath.'/Vagrantfile')) {
            copy(__DIR__.'/../Vagrantfile', $this->basePath.'/Vagrantfile');

            $this->localizeVagrantfile();
        }

        if (! file_exists($this->basePath.'/Homestead.yaml') && ! file_exists($this->basePath.'/Homestead.yaml.example')) {
            copy(__DIR__.'/stubs/Homestead.yaml', $this->basePath.'/Homestead.yaml');

            if ($input->getOption('name')) {
                $this->updateName($input->getOption('name'));
            }

            if ($input->getOption('hostname')) {
                $this->updateHostName($input->getOption('hostname'));
            }

            if ($input->getOption('ip')) {
                $this->updateIpAddress($input->getOption('ip'));
            }
        } elseif (! file_exists($this->basePath.'/Homestead.yaml')) {
            copy($this->basePath.'/Homestead.yaml.example', $this->basePath.'/Homestead.yaml');
        }

        if ($input->getOption('after')) {
            if (! file_exists($this->basePath.'/after.sh')) {
                copy(__DIR__.'/stubs/after.sh', $this->basePath.'/after.sh');
            }
        }

        if ($input->getOption('aliases')) {
            if (! file_exists($this->basePath.'/aliases')) {
                copy(__DIR__.'/stubs/aliases', $this->basePath.'/aliases');
            }
        }

        if ($input->getOption('example')) {
            if (! file_exists($this->basePath.'/Homestead.yaml.example')) {
                copy($this->basePath.'/Homestead.yaml', $this->basePath.'/Homestead.yaml.example');
            }
        }

        $this->configurePaths();

        $output->writeln('Homestead Installed!');
    }

    /**
     * Update paths in Homestead.yaml.
     *
     * @return void
     */
    protected function configurePaths()
    {
        $yaml = str_replace(
            '- map: ~/Code', '- map: "'.str_replace('\\', '/', $this->basePath).'"', $this->getHomesteadFile()
        );

        $yaml = str_replace(
            'to: /home/vagrant/Code', 'to: "/home/vagrant/'.$this->defaultName.'"', $yaml
        );

        // Fix path to the public folder (sites: to:)
        $yaml = str_replace(
            $this->defaultName.'"/Laravel/public', $this->defaultName.'/public"', $yaml
        );

        file_put_contents($this->basePath.'/Homestead.yaml', $yaml);
    }

    /**
     * Update the "name" variable of the Homestead.yaml file.
     *
     * VirtualBox requires a unique name for each virtual machine.
     *
     * @param  string  $name
     * @return void
     */
    protected function updateName($name)
    {
        file_put_contents($this->basePath.'/Homestead.yaml', str_replace(
            'cpus: 1', 'cpus: 1'.PHP_EOL.'name: '.$name, $this->getHomesteadFile()
        ));
    }

    /**
     * Set the virtual machine's hostname setting in the Homestead.yaml file.
     *
     * @param  string  $hostname
     * @return void
     */
    protected function updateHostName($hostname)
    {
        file_put_contents($this->basePath.'/Homestead.yaml', str_replace(
            'cpus: 1', 'cpus: 1'.PHP_EOL.'hostname: '.$hostname, $this->getHomesteadFile()
        ));
    }

    /**
     * Set the virtual machine's IP address setting in the Homestead.yaml file.
     *
     * @param  string  $ip
     * @return void
     */
    protected function updateIpAddress($ip)
    {
        file_put_contents($this->basePath.'/Homestead.yaml', str_replace(
            'ip: "192.168.10.10"', 'ip: "'.$ip.'"', $this->getHomesteadFile()
        ));
    }

    /**
     * Get the contents of the Homestead.yaml file.
     *
     * @return string
     */
    protected function getHomesteadFile()
    {
        return file_get_contents($this->basePath.'/Homestead.yaml');
    }

    /**
     * Update the configuration directory and Homestead directory of the Vagrantfile.
     *
     * @return void
     */
    protected function localizeVagrantfile()
    {
        $vagrantfilePath = $this->basePath.'/Vagrantfile';
        $vagrantfile = file_get_contents($vagrantfilePath);

        $vagrantfile = preg_replace(
            '/^confDir = .+$/m',
            'confDir = $confDir ||= "."',
            $vagrantfile
        );

        $vagrantfile = preg_replace(
            '/^homesteadDir = .+$/m',
            'homesteadDir = $homesteadDir ||= File.expand_path("vendor/laravel/homestead", File.dirname(__FILE__))',
            $vagrantfile
        );

        file_put_contents($vagrantfilePath, $vagrantfile);
    }
}
