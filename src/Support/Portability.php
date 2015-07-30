<?php namespace Laravel\Homestead\Support;

final class Portability
{
    /**
     * How To Open Files?
     *
     * @return string
     */
    public static function editor()
    {
        if (self::isWindows()) {
            return 'start';
        } elseif (self::isMac()) {
            return 'open';
        }

        return 'xdg-open';
    }

    /**
     * Vagrant dotfile path.
     *
     * @return string
     */
    public static function setEnvironmentCommand()
    {
        if (self::isWindows()) {
            return 'SET VAGRANT_DOTFILE_PATH='.$_ENV['VAGRANT_DOTFILE_PATH'].' &&';
        }

        return 'VAGRANT_DOTFILE_PATH="'.$_ENV['VAGRANT_DOTFILE_PATH'].'"';
    }

    /**
     * Operating System Is Windows?
     *
     * @return bool
     */
    private static function isWindows()
    {
        return strpos(strtoupper(PHP_OS), 'WIN') === 0;
    }

    /**
     * Operating System Is OSX?
     *
     * @return bool
     */
    private static function isMac()
    {
        return strpos(strtoupper(PHP_OS), 'DARWIN') === 0;
    }
}
