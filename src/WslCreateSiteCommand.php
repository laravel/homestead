<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
use Laravel\Homestead\Traits\GeneratesSlugs;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class WslCreateSiteCommand extends Command
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
            ->setName('wsl:create-site')
            ->setDescription('Create Sites in WSL from Homestead configuration')
            ->addOption('json', null, InputOption::VALUE_NONE, 'Determines if the Homestead settings file will be in json format.');
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
        // Grab the current settings or create an example configuration
        $format = $input->getOption('json') ? 'json' : 'yaml';
        $settings = $this->parseSettingsFromFile($format, []);

        foreach ($settings['wsl_sites'] as $key => $site) {
            $create_cmd = "";
            $type = "laravel";
            $args = [
                $site['map'],                                 # $1
                $site['to'], # $2
                isset($site['port']) ? $site['port'] : 80,    # $3
                isset($site['ssl']) ? $site['ssl'] : 443,     # $4
                isset($site['php']) ? $site['php'] : "7.4",   # $5
            ];
            $create_cmd = "sudo bash {$this->basePath}/scripts/site-types/{$type}.sh {$args[0]} \"{$args[1]}\"";
            $create_cmd .= " {$args[2]} {$args[3]} {$args[4]}";

            # run command to create the site
            $output = shell_exec($create_cmd);
            if(!isNull($output)) {
                var_dump($output);
            }

            # run command to create the site's SSL certificates
            $cert_cmd = "sudo bash {$this->basePath}/scripts/create-certificate.sh {$site['map']}";
            $output = shell_exec($cert_cmd);
            if(!is_null($output)) {
                var_dump($output);
            }

            # Restart nginx
            $output = shell_exec("sudo service nginx restart");
            if(!is_null($output)) {
                var_dump($output);
            }
        }
        $output->writeln('WSL sites have been created!');

        return 0;
    }

    /**
     * @param string $format
     * @param array $options
     * @return mixed
     */
    protected function parseSettingsFromFile(string $format, array $options)
    {
        $SettingsClass = ($format === 'json') ? JsonSettings::class : YamlSettings::class;
        $filename = __DIR__."/../Homestead.{$format}";

        return $SettingsClass::fromFile($filename)->toArray();
    }
}
