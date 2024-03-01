<?php

namespace Laravel\Homestead;

use Laravel\Homestead\Settings\JsonSettings;
use Laravel\Homestead\Settings\YamlSettings;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class WslApplyFolderMapping extends Command
{
    /**
     * Configure the command options.
     *
     * @return void
     */
    protected function configure()
    {
        $this
            ->setName('wsl:folders')
            ->setDescription('Configure folder mapping in WSL from Homestead configuration')
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

        foreach ($settings['folders'] as $key => $folder) {
            $folder_map = $folder['map'];
            $folder_to = $folder['to'];
            $parent_directory = dirname($folder_to);
            $folder_map_cmd = "rm -r {$folder_to} ; mkdir -p {$parent_directory} && ln -s {$folder_map} {$folder_to}";
            $out = shell_exec($folder_map_cmd);
            print_r($out);
            $output->writeln('Created symbolic link '.$folder_to.' to '.$folder_map.'.');
        }

        $output->writeln('WSL folders have been mapped!');

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