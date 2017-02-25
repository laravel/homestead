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
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml'));
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile'));

        // remove files so we can run the command again on a clean folder
        unlink(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml');
        unlink(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile');
    }

    /**
     * @test
     */
    public function testExecuteMakeWithOptions()
    {
        $makeCommand = new MakeCommand();

        $tester = new CommandTester($makeCommand);
        $tester->execute([
            '--name' => 'fooname',
            '--hostname' => 'foohost',
            '--ip' => '127.0.0.1',
            '--after' => true,
            '--aliases' => true,
            '--example' => true,
            '--json' => true,
        ], []);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json'));
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml.example'));
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'Vagrantfile'));
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'aliases'));
        $this->assertTrue(file_exists(self::$testFolder.DIRECTORY_SEPARATOR.'after.sh'));

        $config = file_get_contents(self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json');
        $config = json_decode($config, true);

        $this->assertTrue($config['ip'] === '127.0.0.1');
        $this->assertTrue($config['name'] === 'fooname');
        $this->assertTrue($config['hostname'] === 'foohost');
    }
}
