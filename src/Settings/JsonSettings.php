<?php

namespace Laravel\Homestead\Settings;

class JsonSettings implements HomesteadSettings
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
     * JsonSettings constructor.
     *
     * @param  string  $filename
     */
    public function __construct($filename)
    {
        $this->attributes = json_decode(file_get_contents($filename), true);
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

        file_put_contents($filename, json_encode($this->attributes, JSON_PRETTY_PRINT));
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
