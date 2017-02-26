<?php

use PHPUnit\Framework\TestCase as TestCase;
use Laravel\Homestead\Settings\JsonSettings;

class HomesteadJsonSettingsTest extends TestCase
{
    /**
     * @var string
     */
    protected static $testFolder;

    public static function setUpBeforeClass()
    {
        self::$testFolder = sys_get_temp_dir().DIRECTORY_SEPARATOR.uniqid('homestead_settings_', true);
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
    public function it_can_be_created_from_a_filename()
    {
        $settings = new JsonSettings(__DIR__.'/../../src/stubs/Homestead.json');

        $attributes = $settings->toArray();
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_be_saved_to_a_file()
    {
        $settings = new JsonSettings(__DIR__.'/../../src/stubs/Homestead.json');
        $filename = self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.json';

        $settings->save($filename);

        $this->assertTrue(file_exists($filename));
        $attributes = json_decode(file_get_contents($filename), true);
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_update_its_attributes()
    {
        $settings = new JsonSettings(__DIR__.'/../../src/stubs/Homestead.json');

        $settings->update([
            'ip' => '127.0.0.1',
            'memory' => '4096',
            'cpus' => 2,
        ]);

        $attributes = $settings->toArray();
        $this->assertEquals('127.0.0.1', $attributes['ip']);
        $this->assertEquals('4096', $attributes['memory']);
        $this->assertEquals(2, $attributes['cpus']);
    }
}
