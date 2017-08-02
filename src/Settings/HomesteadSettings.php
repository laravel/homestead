<?php

namespace Laravel\Homestead\Settings;

abstract class HomesteadSettings
{
    /**
     * Settings attributes.
     *
     * @var array
     */
    protected $attributes;

    /**
     * JsonSettings constructor.
     *
     * @param  array  $attributes
     */
    public function __construct($attributes)
    {
        $this->attributes = $attributes;
    }

    /**
     * Create an instance from a file.
     *
     * @param  string  $filename
     * @return static
     */
    abstract public static function fromFile($filename);

    /**
     * Save the homestead settings.
     *
     * @param  string  $filename
     * @return void
     */
    abstract public function save($filename);

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
     * @param  string  $projectDirectory
     * @return static
     */
    public function configureSites($projectName, $projectDirectory)
    {
        $sites = [
            [
                'map' => "{$projectName}.app",
                'to' => "/home/vagrant/{$projectDirectory}/public",
            ],
        ];

        if (isset($this->attributes['sites']) && ! empty($this->attributes['sites'])) {
            foreach ($this->attributes['sites'] as $index => $user_site) {
                if (isset($user_site['map'])) {
                    $sites[$index]['map'] = $user_site['map'];
                }

                if (isset($user_site['to'])) {
                    $sites[$index]['to'] = $user_site['to'];
                }

                if (isset($user_site['type'])) {
                    $sites[$index]['type'] = $user_site['type'];
                }

                if (isset($user_site['schedule'])) {
                    $sites[$index]['schedule'] = $user_site['schedule'];
                }

                if (isset($user_site['php'])) {
                    $sites[$index]['php'] = $user_site['php'];
                }
            }
        }

        $this->update(['sites' => $sites]);

        return $this;
    }

    /**
     * Configure the shared folders.
     *
     * @param  string  $projectPath
     * @param  string  $projectDirectory
     * @return static
     */
    public function configureSharedFolders($projectPath, $projectDirectory)
    {
        $folders = [
            [
                'map' => $projectPath,
                'to' => "/home/vagrant/{$projectDirectory}",
            ],
        ];

        if (isset($this->attributes['folders']) && ! empty($this->attributes['folders'])) {
            foreach ($this->attributes['folders'] as $index => $user_folder) {
                if (isset($user_folder['to'])) {
                    $folders[$index]['to'] = $user_folder['to'];
                }

                if (isset($user_folder['type'])) {
                    $folders[$index]['type'] = $user_folder['type'];
                }
            }
        }

        $this->update(['folders' => $folders]);

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
