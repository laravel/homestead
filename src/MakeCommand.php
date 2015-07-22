<?php

namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;
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
            ->addOption('name', null, InputOption::VALUE_OPTIONAL, 'The name the virtual machine.', $this->defaultName)
            ->addOption('hostname', null, InputOption::VALUE_OPTIONAL, 'The hostname the virtual machine.', $this->defaultName)
            ->addOption('after', null, InputOption::VALUE_NONE, 'Determines if the after.sh file is created.')
            ->addOption('aliases', null, InputOption::VALUE_NONE, 'Determines if the aliases file is created.')
            ->addOption('json', null, InputOption::VALUE_NONE, 'Determines if the homestead file should be a json file');
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
        $vagrantfile = file_get_contents(__DIR__.'/stubs/LocalizedVagrantfile');
        if( $input->getOption('json') ){
            $vagrantfile = str_replace(
                "homesteadConfigFile = \"Homestead.yaml\"", "homesteadConfigFile = \"Homestead.json\"", $vagrantfile
            );
        }

        file_put_contents($this->basePath.'/Vagrantfile', $vagrantfile);


        if( !$input->getOption('json') ){
            if (!file_exists($this->basePath.'/Homestead.yaml')) {
                copy( __DIR__ . '/stubs/Homestead.yaml', $this->basePath . '/Homestead.yaml' );
            }
        } else {
            if (!file_exists($this->basePath.'/Homestead.json')) {
                copy( __DIR__ . '/stubs/Homestead.json', $this->basePath . '/Homestead.json' );
            }
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
            $this->updateName($input, $input->getOption('name'));
        }

        if ($input->getOption('hostname')) {
            $this->updateHostName($input, $input->getOption('hostname'));
        }

        $this->configurePaths($input);

        $output->writeln('Homestead Installed!');
    }

    /**
     * Update paths in Homestead.yaml
     */
    protected function configurePaths($input)
    {
        if( !$input->getOption('json') ){
            $yaml = str_replace(
                "- map: ~/Code", "- map: \"".str_replace('\\', '/', $this->basePath)."\"", $this->getHomesteadFile($input)
            );

            $yaml = str_replace(
                "to: /home/vagrant/Code", "to: \"/home/vagrant/".$this->defaultName."\"", $yaml
            );

            // Fix path to the public folder (sites: to:)
            $yaml = str_replace(
                $this->defaultName."\"/Laravel/public", $this->defaultName."/public\"", $yaml
            );

            file_put_contents($this->basePath.'/Homestead.yaml', $yaml);
        } else {

            $json = $this->getHomesteadFile($input);

            $json->folders[0]->map = str_replace('\\', '/', $this->basePath);

            $json->folders[0]->to = "/home/vagrant/" . $this->defaultName;

            $json->sites[0]->to = "/home/vagrant/" . $this->defaultName . '/public';

            file_put_contents($this->basePath.'/Homestead.json', json_encode($json, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
        }
    }

    /**
     * Update the "name" variable of the Homestead.yaml file.
     *
     * VirtualBox requires a unique name for each virtual machine.
     *
     * @param  string  $name
     * @return void
     */
    protected function updateName($input, $name)
    {
        if( !$input->getOption('json') ){
            file_put_contents($this->basePath.'/Homestead.yaml', str_replace(
                "cpus: 1", "cpus: 1".PHP_EOL."name: ".$name, $this->getHomesteadFile($input)
            ));
        } else {
            $json = $this->getHomesteadFile($input);
            $json->name = $name;
            file_put_contents($this->basePath.'/Homestead.json', json_encode($json, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
        }

    }

    /**
     * Set the virtual machine's hostname setting in the Homestead.yaml file.
     *
     * @param  string  $hostname
     * @return void
     */
    protected function updateHostName($input, $hostname)
    {
        if( !$input->getOption('json') ){
            file_put_contents($this->basePath.'/Homestead.yaml', str_replace(
                "cpus: 1", "cpus: 1".PHP_EOL."hostname: ".$hostname, $this->getHomesteadFile($input)
            ));
        } else {
            $json = $this->getHomesteadFile($input);
            $json->hostname = $hostname;
            file_put_contents($this->basePath.'/Homestead.json', json_encode($json, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
        }

    }

    /**
     * Get the contents of the Homestead.yaml file.
     *
     * @return string
     */
    protected function getHomesteadFile($input)
    {
        if( !$input->getOption('json') ){
            return file_get_contents($this->basePath.'/Homestead.yaml');
        } else {
            return json_decode(file_get_contents($this->basePath.'/Homestead.json'));
        }

    }
}
