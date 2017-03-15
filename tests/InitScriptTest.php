<?php

namespace Tests;

use PHPUnit\Framework\TestCase as TestCase;

class InitScriptTest extends TestCase
{
    /**
     * @var string
     */
    protected static $testFolder;

    public static function setUpBeforeClass()
    {
        self::$testFolder = sys_get_temp_dir().DIRECTORY_SEPARATOR.uniqid('homestead_', true);
        mkdir(self::$testFolder);
        chdir(self::$testFolder);
    }

    public static function tearDownAfterClass()
    {
        rmdir(self::$testFolder);
    }

    public function setUp()
    {
        $projectDirectory = __DIR__.'/..';

        exec("cp {$projectDirectory}/init.sh ".self::$testFolder);
        exec("cp -r {$projectDirectory}/resources ".self::$testFolder);
    }

    public function tearDown()
    {
        exec('rm -rf '.self::$testFolder.'/*');
    }

    /** @test */
    public function it_displays_a_success_message()
    {
        $output = exec('bash init.sh');

        $this->assertEquals('Homestead initialized!', $output);
    }

    /** @test */
    public function it_creates_a_homestead_yaml_file()
    {
        exec('bash init.sh');

        $this->assertTrue(file_exists(self::$testFolder.'/Homestead.yaml'));
    }

    /** @test */
    public function it_creates_a_homestead_json_file_if_requested()
    {
        exec('bash init.sh json');

        $this->assertTrue(file_exists(self::$testFolder.'/Homestead.json'));
    }

    /** @test */
    public function it_creates_an_after_shell_script()
    {
        exec('bash init.sh');

        $this->assertTrue(file_exists(self::$testFolder.'/after.sh'));
    }

    /** @test */
    public function it_creates_an_aliases_file()
    {
        exec('bash init.sh');

        $this->assertTrue(file_exists(self::$testFolder.'/aliases'));
    }
}
