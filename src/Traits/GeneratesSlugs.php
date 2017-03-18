<?php

namespace Laravel\Homestead\Traits;

trait GeneratesSlugs
{
    /**
     * Generate a slug from a given string.
     *
     * @param  string  $string
     * @return string
     */
    protected function slug($string)
    {
        return strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $string)));
    }
}
