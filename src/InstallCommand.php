<?php namespace Laravel\Homestead;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class InstallCommand extends Command {

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this
            ->setName('install')
            ->setDescription('Install Homestead into the current project')
            ->addOption('name', null, InputOption::VALUE_OPTIONAL, 'The name the virtual machine.')
            ->addOption('hostname', null, InputOption::VALUE_OPTIONAL, 'The hostname the virtual machine.');
        $this->rootPath = str_replace('/vendor/bin/', '', getcwd());
        $this->sourcePath = homestead_path();
        $this->projectFolder = basename(getcwd());
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
        copy(__DIR__.'/stubs/LocalizedVagrantfile', $this->rootPath.'/Vagrantfile');
        copy(__DIR__.'/stubs/Homestead.yaml', $this->rootPath.'/Homestead.yaml');
        copy(__DIR__.'/stubs/after.sh', $this->rootPath.'/after.sh');
        copy(__DIR__.'/stubs/aliases', $this->rootPath.'/aliases');

        if ($input->getOption('name'))
        {
            $this->updateName($input->getOption('name'));
        }

        if ($input->getOption('hostname'))
        {
            $this->updateHostName($input->getOption('hostname'));
        }
        $this->updatePaths();

        $output->writeln('Homestead Installed!');
    }

    /**
     * Update paths in Homestead.yaml
     */
    protected function updatePaths()
    {
        $file = file_get_contents($this->rootPath.'/Homestead.yaml');

        // Update folder map path
        $newFile = str_replace("- map: ~/Code", "- map: ".$this->rootPath, $file);

        // Update folder to path
        $newFile = str_replace("to: /home/vagrant/Code",
            "to: /home/vagrant/".$this->projectFolder,
            $newFile);

        // Fix path to the public folder (sites: to:)
        $newFile = str_replace($this->projectFolder."/Laravel",
            $this->projectFolder,
            $newFile);

        // Save the new file
        file_put_contents($this->rootPath.'/Homestead.yaml', $newFile);
    }

    /**
     * Adds the virtual machine's name setting in the Homstead.yaml
     * This is needed because Virtualbox requires unique names
     * @param $vbName
     */
    protected function updateName($vbName)
    {
        // Update virtualbox name
        $file = file_get_contents($this->rootPath.'/Homestead.yaml');
        $newFile = str_replace("cpus: 1", "cpus: 1".PHP_EOL."name: ".$vbName, $file);

        file_put_contents($this->rootPath.'/Homestead.yaml', $newFile);
    }

    /**
     * Adds the virtual machine's hostname setting in the Homstead.yaml
     * @param $hostname
     */
    protected function updateHostName($hostname)
    {
        // Update virtualbox hostname
        $file = file_get_contents($this->rootPath.'/Homestead.yaml');
        $newFile = str_replace("cpus: 1", "cpus: 1".PHP_EOL."hostname: ".$hostname, $file);

        file_put_contents($this->rootPath.'/Homestead.yaml', $newFile);
    }

}
