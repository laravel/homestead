<?php

namespace Laravel\Homestead\Settings;

interface HomesteadSettings
{
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
     * Convert the homestead settings to an array.
     *
     * @return array
     */
    public function toArray();
}
