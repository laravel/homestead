<?php
namespace Tests;

use PHPUnit_Framework_TestCase as TestCase;
use Laravel\Homestead\MakeCommand;
use Symfony\Component\Console\Tester\CommandTester;

class MakeCommandTest extends TestCase
{
    public static function setUpBeforeClass()
    {
        chdir(dirname(__DIR__));
    }

    public static function tearDownAfterClass()
    {
        if (file_exists('Homestead.yaml')) {
            unlink ('Homestead.yaml');
        }
    }

    public function testConstructor()
    {
        $makeCommand = new MakeCommand();
        $this->assertInstanceOf(MakeCommand::class, $makeCommand);
    }

    public function testExecuteMake()
    {
        $makeCommand = new MakeCommand();

        $tester = new CommandTester($makeCommand);
        $tester->execute([], []);

        $this->assertContains('Homestead Installed!', $tester->getDisplay());
        $this->assertEquals(0, $tester->getStatusCode());
    }
}
