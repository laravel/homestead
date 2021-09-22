<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
use Laravel\Homestead\Traits\GeneratesSlugs;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class WslApplyFeatures extends Command
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
     * Path to features folder.
     *
     * @var string
     */
    private string $featuresPath;

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
        $this->featuresPath = getcwd().'/scripts/features';

        $this
            ->setName('wsl:apply-features')
            ->setDescription('Configure features in WSL from Homestead configuration')
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

        foreach ($settings['features'] as $key => $feature) {
            $feature_cmd = '';
            $feature_name = array_key_first($feature);
            $feature_variables = $feature[$feature_name];

            if ($feature_variables !== false) {
                $feature_path = "{$this->featuresPath}/{$feature_name}.sh > ~/.homestead-features/{$feature_name}.log";
                // Prepare the feature variables if provided.
                if (is_array($feature_variables)) {
                    $variables = join(' ', $feature_variables);
                    $feature_cmd = "sudo -E bash {$feature_path} {$variables}";
                } else {
                    $feature_cmd = "sudo -E bash {$feature_path}";
                }
                shell_exec($feature_cmd);
                $output->writeln("Command output can be found via: sudo cat ~/.homestead-features/{$feature_name}.log");
            }
        }

        $output->writeln('WSL features have been configured!');

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
