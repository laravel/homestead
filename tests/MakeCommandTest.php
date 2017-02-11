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
}
