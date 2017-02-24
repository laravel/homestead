<?php

namespace Tests;

use Laravel\Homestead\MakeCommand;
use PHPUnit\Framework\TestCase as TestCase;
use Symfony\Component\Console\Tester\CommandTester;

class MakeCommandTest extends TestCase
{
    protected static $testFolder;

    public static function setUpBeforeClass()
    {
        self::$testFolder = sys_get_temp_dir().DIRECTORY_SEPARATOR.uniqid('homestead_', true);
        mkdir(self::$testFolder);
        chdir(self::$testFolder);
    }

    public static function tearDownAfterClass()
    {
        array_map('unlink', glob(self::$testFolder.DIRECTORY_SEPARATOR.'*'));
        rmdir(self::$testFolder);
    }

    /**
     * @test
     */
    public function testConstructor()
    {
        $makeCommand = new MakeCommand();
        $this->assertInstanceOf(MakeCommand::class, $makeCommand);
    }

    /**
     * @test
     */
    public function testExecuteMake()
    {
        $makeCommand = new MakeCommand();

        $tester = new CommandTester($makeCommand);
        $tester->execute([], []);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
    }

    /** @test */
    public function an_aliases_file_is_created_if_requested()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--aliases' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'aliases')
        );
        $this->assertEquals(
            file_get_contents(__DIR__.'/../src/stubs/aliases'),
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'aliases')
        );
    }

    /** @test */
    public function an_existing_aliases_file_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'aliases',
            'Already existing aliases'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--aliases' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'aliases')
        );
        $this->assertEquals(
            'Already existing aliases',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'aliases')
        );
    }

    /** @test */
    public function an_after_shell_script_is_created_if_requested()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--after' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'after.sh')
        );
        $this->assertEquals(
            file_get_contents(__DIR__.'/../src/stubs/after.sh'),
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'after.sh')
        );
    }

    /** @test */
    public function an_existing_after_shell_script_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'after.sh',
            'Already existing after.sh'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--after' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'after.sh')
        );
        $this->assertEquals(
            'Already existing after.sh',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'after.sh')
        );
    }

    /** @test */
    public function an_example_homestead_yaml_settings_is_created_if_requested()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--example' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example')
        );
        $this->assertEquals(
            file_get_contents(__DIR__.'/../src/stubs/Homestead.yaml'),
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example')
        );
    }

    /** @test */
    public function an_existing_example_homestead_yaml_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example',
            'Already existing Homestead.yaml.example'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--example' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example')
        );
        $this->assertEquals(
            'Already existing Homestead.yaml.example',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example')
        );
    }

    /** @test */
    public function an_example_homestead_json_settings_is_created_if_requested()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--example' => true,
            '--json' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example')
        );
        $this->assertEquals(
            file_get_contents(__DIR__.'/../src/stubs/Homestead.json'),
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example')
        );
    }

    /** @test */
    public function an_existing_example_homestead_json_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example',
            'Already existing Homestead.json.example'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--example' => true,
            '--json' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example')
        );
        $this->assertEquals(
            'Already existing Homestead.json.example',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example')
        );
    }
}
