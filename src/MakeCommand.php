<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
use Laravel\Homestead\Traits\GeneratesSlugs;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class MakeCommand extends Command
{
    use GeneratesSlugs;

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
        $this->projectName = basename($this->basePath);
        $this->defaultName = $this->slug($this->projectName);

        $this
            ->setName('make')
            ->setDescription('Install Homestead into the current project')
            ->addOption('name', null, InputOption::VALUE_OPTIONAL, 'The name of the virtual machine.', $this->defaultName)
            ->addOption('hostname', null, InputOption::VALUE_OPTIONAL, 'The hostname of the virtual machine.', $this->defaultName)
            ->addOption('ip', null, InputOption::VALUE_OPTIONAL, 'The IP address of the virtual machine.')
            ->addOption('no-after', null, InputOption::VALUE_NONE, 'Determines if the after.sh file is not created.')
            ->addOption('no-aliases', null, InputOption::VALUE_NONE, 'Determines if the aliases file is not created.')
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

        if (! $input->getOption('no-aliases') && ! $this->aliasesFileExists()) {
            $this->createAliasesFile();
        }

        if (! $input->getOption('no-after') && ! $this->afterShellScriptExists()) {
            $this->createAfterShellScript();
        }

        $format = $input->getOption('json') ? 'json' : 'yaml';

        if (! $this->settingsFileExists($format)) {
            $this->createSettingsFile($format, [
                'name' => $input->getOption('name'),
                'hostname' => $input->getOption('hostname'),
                'ip' => $input->getOption('ip'),
            ]);
        }

        if ($input->getOption('example') && ! $this->exampleSettingsExists($format)) {
            $this->createExampleSettingsFile($format);
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
        copy(__DIR__.'/../resources/LocalizedVagrantfile', "{$this->basePath}/Vagrantfile");
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
        copy(__DIR__.'/../resources/aliases', "{$this->basePath}/aliases");
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
        copy(__DIR__.'/../resources/after.sh', "{$this->basePath}/after.sh");
    }

    /**
     * Determine if the settings file exists.
     *
     * @param  string  $format
     * @return bool
     */
    protected function settingsFileExists($format)
    {
        return file_exists("{$this->basePath}/Homestead.{$format}");
    }

    /**
     * Create the homestead settings file.
     *
     * @param  string  $format
     * @param  array  $options
     * @return void
     */
    protected function createSettingsFile($format, $options)
    {
        $SettingsClass = ($format === 'json') ? JsonSettings::class : YamlSettings::class;

        $filename = $this->exampleSettingsExists($format) ?
            "{$this->basePath}/Homestead.{$format}.example" :
            __DIR__."/../resources/Homestead.{$format}";

        $settings = $SettingsClass::fromFile($filename);

        if (! $this->exampleSettingsExists($format)) {
            $settings->updateName($options['name'])
                     ->updateHostname($options['hostname']);
        }

        $settings->updateIpAddress($options['ip'])
                 ->configureSites($this->projectName, $this->defaultName)
                 ->configureSharedFolders($this->basePath, $this->defaultName)
                 ->save("{$this->basePath}/Homestead.{$format}");
    }

    /**
     * Determine if the example settings file exists.
     *
     * @param  string  $format
     * @return bool
     */
    protected function exampleSettingsExists($format)
    {
        return file_exists("{$this->basePath}/Homestead.{$format}.example");
    }

    /**
     * Create the homestead settings example file.
     *
     * @param  string  $format
     * @return void
     */
    protected function createExampleSettingsFile($format)
    {
        copy("{$this->basePath}/Homestead.{$format}", "{$this->basePath}/Homestead.{$format}.example");
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
