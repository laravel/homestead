<?php

namespace Tests\Settings;

use Symfony\Component\Yaml\Yaml;
use PHPUnit\Framework\TestCase as TestCase;
use Laravel\Homestead\Settings\YamlSettings;

class YamlSettingsTest extends TestCase
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
        $settings = YamlSettings::fromFile(__DIR__.'/../../src/stubs/Homestead.yaml');

        $attributes = $settings->toArray();
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_be_saved_to_a_file()
    {
        $settings = new YamlSettings([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => 1,
        ]);
        $filename = self::$testFolder.DIRECTORY_SEPARATOR.'Homestead.yaml';

        $settings->save($filename);

        $this->assertTrue(file_exists($filename));
        $attributes = Yaml::parse(file_get_contents($filename));
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_update_its_attributes()
    {
        $settings = new YamlSettings([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => 1,
        ]);

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

    /** @test */
    public function it_updates_only_not_null_attributes()
    {
        $settings = new YamlSettings([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => 1,
        ]);

        $settings->update([
            'ip' => null,
            'memory' => null,
            'cpus' => null,
        ]);

        $attributes = $settings->toArray();
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_update_its_name()
    {
        $settings = new YamlSettings(['name' => 'Initial name']);

        $settings->updateName('Updated name');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated name', $attributes['name']);
    }

    /** @test */
    public function it_can_update_its_hostname()
    {
        $settings = new YamlSettings(['name' => 'Initial ip address']);

        $settings->updateHostname('Updated hostname');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated hostname', $attributes['hostname']);
    }

    /** @test */
    public function it_can_update_its_ip_address()
    {
        $settings = new YamlSettings(['name' => 'Initial ip address']);

        $settings->updateIpAddress('Updated ip address');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated ip address', $attributes['ip']);
    }

    /** @test */
    public function it_can_configure_its_sites()
    {
        $settings = new YamlSettings([
            'sites' => [
                'map' => 'homestead.app',
                'to' => '/home/vagrant/Code/Laravel/public',
            ],
        ]);

        $settings->configureSites('test.com', 'test-com');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => 'test.com.app',
            'to' => '/home/vagrant/Code/test-com/public',
        ], $attributes['sites'][0]);
    }

    /** @test */
    public function it_can_configure_its_shared_folders()
    {
        $settings = new YamlSettings([
            'folders' => [
                'map' => '~/Code',
                'to' => '/home/vagrant/Code',
            ],
        ]);

        $settings->configureSharedFolders('/a/path/for/project_name', 'project_name');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => '/a/path/for/project_name',
            'to' => '/home/vagrant/Code/project_name',
        ], $attributes['folders'][0]);
    }
}
