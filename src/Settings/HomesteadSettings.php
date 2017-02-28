<?php

namespace Laravel\Homestead\Settings;

interface HomesteadSettings
{
    /**
     * Create an instance from a file.
     *
     * @param  string  $filename
     * @return static
     */
    public static function fromFile($filename);

    /**
     * Save the homestead settings.
     *
     * @param  string  $filename
     * @return void
     */
    public function save($filename);

    /**
     * Update the homestead settings.
     *
     * @param  array  $attributes
     * @return void
     */
    public function update($attributes);

    /**
     * Update the virtual machine's name.
     *
     * @param  string  $name
     * @return static
     */
    public function updateName($name);

    /**
     * Update the virtual machine's hostname.
     *
     * @param  string  $hostname
     * @return static
     */
    public function updateHostname($hostname);

    /**
     * Update the virtual machine's IP address.
     *
     * @param  string  $ip
     * @return static
     */
    public function updateIpAddress($ip);

    /**
     * Configure the nginx sites.
     *
     * @param  string  $projectName
     * @return static
     */
    public function configureSites($projectName);

    /**
     * Configure the shared folders.
     *
     * @param  string  $projectPath
     * @param  string  $projectName
     * @return static
     */
    public function configureSharedFolders($projectPath, $projectName);

    /**
     * Convert the homestead settings to an array.
     *
     * @return array
     */
    public function toArray();
}
