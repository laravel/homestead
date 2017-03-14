<?php

namespace Laravel\Homestead\Settings;

use Symfony\Component\Yaml\Yaml;

class YamlSettings extends HomesteadSettings
{
    /**
     * Create an instance from a file.
     *
     * @param  string  $filename
     * @return static
     */
    public static function fromFile($filename)
    {
        return new static(Yaml::parse(file_get_contents($filename)));
    }

    /**
     * Save the homestead settings.
     *
     * @param  string  $filename
     * @return void
     */
    public function save($filename)
    {
        file_put_contents($filename, Yaml::dump($this->attributes, 3));
    }
}
