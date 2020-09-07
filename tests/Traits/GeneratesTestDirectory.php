<?php

namespace Tests\Traits;

trait GeneratesTestDirectory
{
    /**
     * @var string
     */
    protected static $testDirectory;

    /**
     * Create a tests directory and make it the current directory.
     *
     * @return void
     */
    public static function setUpBeforeClass(): void
    {
        self::$testDirectory = sys_get_temp_dir().DIRECTORY_SEPARATOR.uniqid('homestead_', true);
        mkdir(self::$testDirectory);
        chdir(self::$testDirectory);
    }

    /**
     * Delete the tests directory.
     *
     * @return void
     */
    public static function tearDownAfterClass(): void
    {
        rmdir(self::$testDirectory);
    }

    /**
     * Delete all the files inside the tests directory.
     *
     * @return void
     */
    public function tearDown(): void
    {
        exec('rm -rf '.self::$testDirectory.DIRECTORY_SEPARATOR.'*');
    }
}
