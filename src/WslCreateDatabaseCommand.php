<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
use Laravel\Homestead\Traits\GeneratesSlugs;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class WslCreateDatabaseCommand extends Command
{
    use GeneratesSlugs;

    /**
     * The base path of the Laravel installation.
     *
     * @var string
     */
    protected string $basePath;

    /**
     * The name of the project folder.
     *
     * @var string
     */
    protected string $projectName;

    /**
     * Sluggified Project Name.
     *
     * @var string
     */
    protected string $defaultProjectName;

    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this->basePath = getcwd();
        $this->projectName = basename($this->basePath);
        $this->defaultProjectName = $this->slug($this->projectName);

        $this
            ->setName('wsl:create-databases')
            ->setDescription('Create Databases in WSL from Homestead configuration')
            ->addOption('json', null, InputOption::VALUE_NONE, 'Determines if the Homestead settings file will be in json format.');
    }

    /**
     * Execute the command.
     *
     * @param  InputInterface  $input
     * @param  OutputInterface  $output
     * @return int
     */
    public function execute(InputInterface $input, OutputInterface $output)
    {
        // Grab the current settings or create an example configuration
        $format = $input->getOption('json') ? 'json' : 'yaml';
        $settings = $this->parseSettingsFromFile($format, []);

        foreach ($settings['databases'] as $db) {
            $create_cmd = '';
            $query = "CREATE DATABASE IF NOT EXISTS {$db} DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
            $create_cmd = 'mysql -u homestead -psecret -e "'.$query.'"';
            // run command to create the database
            $shell_output = shell_exec($create_cmd);
            if (! is_null($shell_output)) {
                var_dump($shell_output);
            }
        }
        $output->writeln('WSL Databases have been created!');

        return 0;
    }

    /**
     * @param  string  $format
     * @param  array  $options
     * @return mixed
     */
    protected function parseSettingsFromFile(string $format, array $options)
    {
        $SettingsClass = ($format === 'json') ? JsonSettings::class : YamlSettings::class;
        $filename = __DIR__."/../Homestead.{$format}";

        return $SettingsClass::fromFile($filename)->toArray();
    }
}
