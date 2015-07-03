<?php

namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Yaml\Yaml;

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
            ->addOption('name', null, InputOption::VALUE_OPTIONAL, 'The name the virtual machine.', $this->defaultName)
            ->addOption('hostname', null, InputOption::VALUE_OPTIONAL, 'The hostname the virtual machine.', $this->defaultName)
            ->addOption('after', null, InputOption::VALUE_NONE, 'Determines if the after.sh file is created.')
            ->addOption('aliases', null, InputOption::VALUE_NONE, 'Determines if the aliases file is created.');
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
        copy(__DIR__.'/stubs/LocalizedVagrantfile', $this->basePath.'/Vagrantfile');

        if (!file_exists($this->basePath.'/Homestead.yaml')) {
            copy( __DIR__ . '/stubs/Homestead.yaml', $this->basePath . '/Homestead.yaml' );
        }

        if ($input->getOption('after')) {
            if (!file_exists($this->basePath.'/after.sh')) {
                copy( __DIR__ . '/stubs/after.sh', $this->basePath . '/after.sh' );
            }
        }

        if ($input->getOption('aliases')) {
            if (!file_exists($this->basePath.'/aliases')) {
                copy( __DIR__ . '/stubs/aliases', $this->basePath . '/aliases' );
            }
        }

        if ($input->getOption('name')) {
            $this->updateName($input->getOption('name'));
        }

        if ($input->getOption('hostname')) {
            $this->updateHostName($input->getOption('hostname'));
        }

        $this->configurePaths();

        $output->writeln('Homestead Installed!');
    }

    /**
     * Update paths in Homestead.yaml
     */
    protected function configurePaths()
    {
        // Get Homestead.yaml as an array
        $homesteadFile = $this->getHomesteadFile();
        // Update host folder path
        $homesteadFile['folders'][0]['map'] = $this->basePath;
        // Update guest folder path
        $homesteadFile['folders'][0]['to'] = "/home/vagrant/".$this->defaultName;
        // Update public folder path
        $homesteadFile['sites'][0]['to'] = $homesteadFile['folders'][0]['to'] . "/public";
        // Save array back to Homestead.yaml as yaml
        $this->saveHomesteadFile($homesteadFile);
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
        // Get Homestead.yaml as an array
        $homesteadFile = $this->getHomesteadFile();
        // Add name to the 4th position in the array
        $homesteadFile = array_slice($homesteadFile, 0, 3, true) +
                    array('name' => $name) +
                    array_slice($homesteadFile, 3, NULL, true);
        // Save array back to Homestead.yaml as yaml
        $this->saveHomesteadFile($homesteadFile);
    }
    
    /**
     * Set the virtual machine's hostname setting in the Homestead.yaml file.
     *
     * @param  string  $hostname
     * @return void
     */
    protected function updateHostName($hostname)
    {
        // Get Homestead.yaml as an array
        $homesteadFile = $this->getHomesteadFile();
        // Add name to the 4th position in the array
        $homesteadFile = array_slice($homesteadFile, 0, 3, true) +
                    array('hostname' => $hostname) +
                    array_slice($homesteadFile, 3, NULL, true);
        // Save array back to Homestead.yaml as yaml
        $this->saveHomesteadFile($homesteadFile);
    }

    /**
     * Get the contents of the Homestead.yaml file.
     *
     * @return array
     */
    protected function getHomesteadFile()
    {
        return Yaml::parse(file_get_contents($this->basePath.'/Homestead.yaml'));
    }

    /**
     * Get the contents of the Homestead.yaml file.
     *
     * @param  array  $array
     * @return void
     */    
    protected function saveHomesteadFile($array)
    {
        $yaml = Yaml::dump($array, 3);
        file_put_contents($this->basePath.'/Homestead.yaml', $yaml);
    }
}
