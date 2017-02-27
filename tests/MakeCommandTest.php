<?php

namespace Tests;

use Symfony\Component\Yaml\Yaml;
use Laravel\Homestead\MakeCommand;
use PHPUnit\Framework\TestCase as TestCase;
use Symfony\Component\Console\Tester\CommandTester;

class MakeCommandTest extends TestCase
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

    public function tearDown()
    {
        array_map('unlink', glob(self::$testFolder.DIRECTORY_SEPARATOR.'*'));
    }

    /** @test */
    public function a_vagrantfile_is_created_if_it_does_not_exists()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile')
        );
        $this->assertEquals(
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile'),
            file_get_contents(__DIR__.'/../src/stubs/LocalizedVagrantfile')
        );
    }

    /** @test */
    public function an_existing_vagrantfile_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile',
            'Already existing Vagrantfile'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertEquals(
            'Already existing Vagrantfile',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile')
        );
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
    }

    /** @test */
    public function an_existing_example_homestead_yaml_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example',
            'name: Already existing Homestead.yaml.example'
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
            'name: Already existing Homestead.yaml.example',
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
    }

    /** @test */
    public function an_existing_example_homestead_json_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example',
            '{"name": "Already existing Homestead.json.example"}'
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
            '{"name": "Already existing Homestead.json.example"}',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example')
        );
    }

    /** @test */
    public function a_homestead_yaml_settings_is_created_if_it_is_does_not_exists()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml')
        );
    }

    /** @test */
    public function an_existing_homestead_yaml_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml',
            'name: Already existing Homestead.yaml'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml')
        );
        $this->assertEquals(
            'name: Already existing Homestead.yaml',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml')
        );
    }

    /** @test */
    public function a_homestead_json_settings_is_created_if_it_is_requested_and_it_does_not_exists()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--json' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json')
        );
    }

    /** @test */
    public function an_existing_homestead_json_settings_is_not_overwritten()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json',
            '{"message": "Already existing Homestead.json"}'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json')
        );
        $this->assertEquals(
            '{"message": "Already existing Homestead.json"}',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json')
        );
    }

    /** @test */
    public function a_homestead_yaml_settings_is_created_from_a_homestead_yaml_example_if_it_exists()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example',
            "message: 'Already existing Homestead.yaml.example'"
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml')
        );
        $this->assertContains(
            "message: 'Already existing Homestead.yaml.example'",
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml')
        );
    }

    /** @test */
    public function a_homestead_json_settings_is_created_from_a_homestead_json_example_if_is_requested_and_if_it_exists()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json.example',
            '{"message": "Already existing Homestead.json.example"}'
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--json' => true,
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(
            file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json')
        );
        $this->assertContains(
            '"message": "Already existing Homestead.json.example"',
            file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json')
        );
    }

    /** @test */
    public function a_homestead_yaml_settings_can_be_created_with_some_command_options_overrides()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--name' => 'test_name',
            '--hostname' => 'test_hostname',
            '--ip' => '127.0.0.1',
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml'));
        $settings = Yaml::parse(file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml'));
        $this->assertEquals('test_name', $settings['name']);
        $this->assertEquals('test_hostname', $settings['hostname']);
        $this->assertEquals('127.0.0.1', $settings['ip']);
    }

    /** @test */
    public function a_homestead_json_settings_can_be_created_with_some_command_options_overrides()
    {
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([
            '--json' => true,
            '--name' => 'test_name',
            '--hostname' => 'test_hostname',
            '--ip' => '127.0.0.1',
        ]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json'));
        $settings = json_decode(file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json'), true);
        $this->assertEquals('test_name', $settings['name']);
        $this->assertEquals('test_hostname', $settings['hostname']);
        $this->assertEquals('127.0.0.1', $settings['ip']);
    }

    /** @test */
    public function a_warning_is_thrown_if_the_homestead_settings_json_and_yaml_exists_at_the_same_time()
    {
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json',
            '{"message": "Already existing Homestead.json"}'
        );
        file_put_contents(
            self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml',
            "message: 'Already existing Homestead.yaml'"
        );
        $tester = new CommandTester(new MakeCommand());

        $tester->execute([]);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertContains('WARNING! You have Homestead.yaml AND Homestead.json configuration files', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
    }
}
