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
            ->setName('wsl:create-sites')
            ->setDescription('Create Sites in WSL from Homestead configuration')
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
        // Remove any existing nginx sites
        $shell_output = shell_exec('sudo rm -rf /etc/nginx/sites-available/*');
        if (! is_null($shell_output)) {
            var_dump($shell_output);
        }

        // Grab the current settings or create an example configuration
        $format = $input->getOption('json') ? 'json' : 'yaml';
        $settings = $this->parseSettingsFromFile($format, []);

        foreach ($settings['wsl_sites'] as $key => $site) {
            $type = $site['type'] ?? 'laravel';
            $create_cmd = '';
            $headers = false;
            $rewrites = false;
            // check & process headers
            if (array_key_exists('headers', $site)) {
                foreach ($site['headers'] as $header) {
                    $headers[$header['key']] = $header['value'];
                }
            }
            // check & process rewrites
            if (array_key_exists('rewrites', $site)) {
                foreach ($site['rewrites'] as $rewrite) {
                    $rewrites[$rewrite['map']] = $rewrite['to'];
                }
            }

            $args = [
                $site['map'],           // $0
                $site['to'],            // $1
                $site['port'] ?? 80,    // $2
                $site['ssl'] ?? 443,    // $3
                $site['php'] ?? '8.0',  // $4
                '',                     // $5 params
                $site['xhgui'] ?? '',   // $6
                $site['exec'] ?? false, // $7
                $headers,               // $8 headers
                $rewrites,              // $9 rewrites
            ];

            $create_cmd = "sudo bash {$this->basePath}/scripts/site-types/{$type}.sh {$args[0]} \"{$args[1]}\"";
            $create_cmd .= " {$args[2]} {$args[3]} {$args[4]} {$args[5]} {$args[6]} {$args[7]} {$args[8]} {$args[9]}";

            // run command to create the site
            $shell_output = shell_exec($create_cmd);
            if (! is_null($shell_output)) {
                var_dump($shell_output);
            }

            // run command to create the site's SSL certificates
            $cert_cmd = "sudo bash {$this->basePath}/scripts/create-certificate.sh {$site['map']}";
            $shell_output = shell_exec($cert_cmd);
            if (! is_null($shell_output)) {
                var_dump($shell_output);
            }

            // Restart nginx
            $shell_output = shell_exec('sudo service nginx restart');
            if (! is_null($shell_output)) {
                var_dump($shell_output);
            }
        }
        $output->writeln('WSL sites have been created!');

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
