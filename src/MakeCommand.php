<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
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
            ->addOption('example', null, InputOption::VALUE_NONE, 'Determines if a Homestead example file is created.')
            ->addOption('json', null, InputOption::VALUE_NONE, 'Determines if the Homestead settings file will be in json format.');
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
        if (! $this->vagrantfileExists()) {
            $this->createVagrantfile();
        }

        if ($input->getOption('aliases') && ! $this->aliasesFileExists()) {
            $this->createAliasesFile();
        }

        if ($input->getOption('after') && ! $this->afterShellScriptExists()) {
            $this->createAfterShellScript();
        }

        $fileExtension = $input->getOption('json') ? 'json' : 'yaml';
        $settingsClass = ($fileExtension == 'json') ? JsonSettings::class : YamlSettings::class;

        if (! $this->exampleSettingsExists($fileExtension) && ! $this->settingsFileExists($fileExtension)) {
            $settings = new $settingsClass(__DIR__."/stubs/Homestead.{$fileExtension}");

            $settings->update([
                'name' => $input->getOption('name'),
                'hostname' => $input->getOption('hostname'),
                'ip' => $input->getOption('ip'),
            ])->save("{$this->basePath}/Homestead.{$fileExtension}");

            if ($input->getOption('example')) {
                $settings->save("{$this->basePath}/Homestead.{$fileExtension}.example");
            }
        } elseif ($this->exampleSettingsExists($fileExtension) && ! $this->settingsFileExists($fileExtension)) {
            $settings = new $settingsClass("{$this->basePath}/Homestead.{$fileExtension}.example");

            $settings->update([
                'name' => $input->getOption('name'),
                'hostname' => $input->getOption('hostname'),
                'ip' => $input->getOption('ip'),
            ])->save("{$this->basePath}/Homestead.{$fileExtension}");
        }

        $this->checkForDuplicateConfigs($output);

        $output->writeln('Homestead Installed!');
    }

    /**
     * Determine if the Vagrantfile exists.
     *
     * @return bool
     */
    protected function vagrantfileExists()
    {
        return file_exists("{$this->basePath}/Vagrantfile");
    }

    /**
     * Create a Vagrantfile.
     *
     * @return void
     */
    protected function createVagrantfile()
    {
        copy(__DIR__.'/stubs/LocalizedVagrantfile', "{$this->basePath}/Vagrantfile");
    }

    /**
     * Determine if the aliases file exists.
     *
     * @return bool
     */
    protected function aliasesFileExists()
    {
        return file_exists("{$this->basePath}/aliases");
    }

    /**
     * Create aliases file.
     *
     * @return void
     */
    protected function createAliasesFile()
    {
        copy(__DIR__.'/stubs/aliases', "{$this->basePath}/aliases");
    }

    /**
     * Determine if the after shell script exists.
     *
     * @return bool
     */
    protected function afterShellScriptExists()
    {
        return file_exists("{$this->basePath}/after.sh");
    }

    /**
     * Create the after shell script.
     *
     * @return void
     */
    protected function createAfterShellScript()
    {
        copy(__DIR__.'/stubs/after.sh', "{$this->basePath}/after.sh");
    }

    /**
     * Determine if the settings file exists.
     *
     * @param  string  $fileExtension
     * @return bool
     */
    protected function settingsFileExists($fileExtension)
    {
        return file_exists("{$this->basePath}/Homestead.{$fileExtension}");
    }

    /**
     * Determine if the example settings file exists.
     *
     * @param  string  $fileExtension
     * @return bool
     */
    protected function exampleSettingsExists($fileExtension)
    {
        return file_exists("{$this->basePath}/Homestead.{$fileExtension}.example");
    }

    /**
     * Checks if JSON and Yaml config files exist, if they do
     * the user is warned that Yaml will be used before
     * JSON until Yaml is renamed / removed.
     *
     * @param  OutputInterface  $output
     * @return void
     */
    protected function checkForDuplicateConfigs(OutputInterface $output)
    {
        if (file_exists("{$this->basePath}/Homestead.yaml") && file_exists("{$this->basePath}/Homestead.json")) {
            $output->writeln(
                '<error>WARNING! You have Homestead.yaml AND Homestead.json configuration files</error>'
            );
            $output->writeln(
                '<error>WARNING! Homestead will not use Homestead.json until you rename or delete the Homestead.yaml</error>'
            );
        }
    }
}
