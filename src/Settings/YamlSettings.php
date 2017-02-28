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
     * YamlSettings constructor.
     *
     * @param  array  $attributes
     */
    public function __construct($attributes = [])
    {
        $this->attributes = $attributes;
    }

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
        $this->attributes = array_merge($this->attributes, array_filter($attributes, function ($attribute) {
            return ! is_null($attribute);
        }));

        return $this;
    }

    /**
     * Update the virtual machine's name.
     *
     * @param  string  $name
     * @return static
     */
    public function updateName($name)
    {
        $this->update(['name' => $name]);

        return $this;
    }

    /**
     * Update the virtual machine's hostname.
     *
     * @param  string  $hostname
     * @return static
     */
    public function updateHostname($hostname)
    {
        $this->update(['hostname' => $hostname]);

        return $this;
    }

    /**
     * Update the virtual machine's IP address.
     *
     * @param  string  $ip
     * @return static
     */
    public function updateIpAddress($ip)
    {
        $this->update(['ip' => $ip]);

        return $this;
    }

    /**
     * Configure the nginx sites.
     *
     * @param  string  $projectName
     * @return static
     */
    public function configureSites($projectName)
    {
        $site = [
            'map' => "{$projectName}.app",
            'to' => "/home/vagrant/Code/{$projectName}/public",
        ];

        $this->update(['sites' => [$site]]);

        return $this;
    }

    /**
     * Configure the shared folders.
     *
     * @param  string  $projectPath
     * @param  string  $projectName
     * @return static
     */
    public function configureSharedFolders($projectPath, $projectName)
    {
        $folder = [
            'map' => $projectPath,
            'to' => "/home/vagrant/Code/{$projectName}",
        ];

        $this->update(['folders' => [$folder]]);

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
