<?php

namespace Tests\Settings;

use Tests\Traits\GeneratesTestDirectory;
use PHPUnit\Framework\TestCase as TestCase;
use Laravel\Homestead\Settings\JsonSettings;

class JsonSettingsTest extends TestCase
{
    use GeneratesTestDirectory;

    /** @test */
    public function it_can_be_created_from_a_filename()
    {
        $settings = JsonSettings::fromFile(__DIR__.'/../../resources/Homestead.json');

        $attributes = $settings->toArray();
        $this->assertEquals('192.168.10.10', $attributes['ip']);
        $this->assertEquals('2048', $attributes['memory']);
        $this->assertEquals(1, $attributes['cpus']);
    }

    /** @test */
    public function it_can_be_saved_to_a_file()
    {
        $settings = new JsonSettings([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => 1,
        ]);
        $filename = self::$testDirectory.DIRECTORY_SEPARATOR.'Homestead.json';

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
        $settings = new JsonSettings([
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
        $settings = new JsonSettings([
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
        $settings = new JsonSettings(['name' => 'Initial name']);

        $settings->updateName('Updated name');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated name', $attributes['name']);
    }

    /** @test */
    public function it_can_update_its_hostname()
    {
        $settings = new JsonSettings(['name' => 'Initial ip address']);

        $settings->updateHostname('Updated hostname');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated hostname', $attributes['hostname']);
    }

    /** @test */
    public function it_can_update_its_ip_address()
    {
        $settings = new JsonSettings(['name' => 'Initial ip address']);

        $settings->updateIpAddress('Updated ip address');

        $attributes = $settings->toArray();
        $this->assertEquals('Updated ip address', $attributes['ip']);
    }

    /** @test */
    public function it_can_configure_its_sites()
    {
        $settings = new JsonSettings([
            'sites' => [
                [
                    'map' => 'homestead.app',
                    'to' => '/home/vagrant/Code/Laravel/public',
                    'type' => 'laravel',
                    'schedule' => true,
                ],
            ],
        ]);

        $settings->configureSites('test.com', 'test-com');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => 'test.com.app',
            'to' => '/home/vagrant/Code/test-com/public',
            'type' => 'laravel',
            'schedule' => true,
        ], $attributes['sites'][0]);
    }

    /** @test */
    public function it_can_configure_its_shared_folders()
    {
        $settings = new JsonSettings([
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
