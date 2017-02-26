<?php

namespace Laravel\Homestead\Settings;

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
        $this->attributes = yaml_parse_file($filename);
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

        yaml_emit_file($filename, $this->attributes, YAML_UTF8_ENCODING);
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
