<?php

namespace Laravel\Homestead\Settings;

use Symfony\Component\Yaml\Yaml;

class YamlSettings implements HomesteadSettings
{
    /**
     * Settings attributes.
     *
     * @var array
     */
    protected $attributes;

    /**
     * Settings filename.
     *
     * @var string
     */
    protected $filename;

    /**
     * YamlSettings constructor.
     *
     * @param  string  $filename
     */
    public function __construct($filename)
    {
        $this->attributes = Yaml::parse(file_get_contents($filename));
    }

    /**
     * Save the homestead settings.
     *
     * @param  string  $filename
     * @return void
     */
    public function save($filename)
    {
        $this->filename = $filename;

        file_put_contents($filename, Yaml::dump($this->attributes));
    }

    /**
     * Update the homestead settings.
     *
     * @param  array  $attributes
     * @return static
     */
    public function update($attributes)
    {
        $this->attributes = array_merge($this->attributes, $attributes);

        return $this;
    }

    /**
     * Convert the homestead settings to an array.
     *
     * @return array
     */
    public function toArray()
    {
        return $this->attributes;
    }
}
