<?php

namespace Tests;

use Tests\Traits\GeneratesTestDirectory;
use PHPUnit\Framework\TestCase as TestCase;

class InitScriptTest extends TestCase
{
    use GeneratesTestDirectory;

    /**
     * Copies init.sh and resources directory to the temporal directory.
     */
    public function setUp()
    {
        $projectDirectory = __DIR__.'/..';

        exec("cp {$projectDirectory}/init.sh ".self::$testDirectory);
        exec("cp -r {$projectDirectory}/resources ".self::$testDirectory);
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

        $this->assertTrue(file_exists(self::$testDirectory.'/Homestead.yaml'));
    }

    /** @test */
    public function it_creates_a_homestead_json_file_if_requested()
    {
        exec('bash init.sh json');

        $this->assertTrue(file_exists(self::$testDirectory.'/Homestead.json'));
    }

    /** @test */
    public function it_creates_an_after_shell_script()
    {
        exec('bash init.sh');

        $this->assertTrue(file_exists(self::$testDirectory.'/after.sh'));
    }

    /** @test */
    public function it_creates_an_aliases_file()
    {
        exec('bash init.sh');

        $this->assertTrue(file_exists(self::$testDirectory.'/aliases'));
    }
}
