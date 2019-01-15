<?php

namespace Tests\Settings;

use PHPUnit\Framework\TestCase;
use Tests\Traits\GeneratesTestDirectory;
use Laravel\Homestead\Settings\JsonSettings;

class JsonSettingsTest extends TestCase
{
    use GeneratesTestDirectory;

    /** @test */
    public function it_can_be_created_from_a_filename()
    {
        $settings = JsonSettings::fromFile(__DIR__.'/../../resources/Homestead.json');

        $this->assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '1',
        ], $settings->toArray());
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

        $this->assertFileExists($filename);
        $attributes = json_decode(file_get_contents($filename), true);
        $this->assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '1',
        ], $settings->toArray());
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

        $this->assertArraySubset([
            'ip' => '127.0.0.1',
            'memory' => '4096',
            'cpus' => '2',
        ], $settings->toArray());
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

        $this->assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '1',
        ], $settings->toArray());
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
    public function it_can_configure_its_sites_from_existing_settings()
    {
        $settings = new JsonSettings([
            'sites' => [
                [
                    'map' => 'homestead.test',
                    'to' => '/home/vagrant/Laravel/public',
                    'type' => 'laravel',
                    'schedule' => true,
                    'php' => '7.1',
                ],
            ],
        ]);

        $settings->configureSites('test.com', 'test-com');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => 'homestead.test',
            'to' => '/home/vagrant/Laravel/public',
            'type' => 'laravel',
            'schedule' => true,
            'php' => '7.1',
        ], $attributes['sites'][0]);
    }

    /** @test */
    public function it_can_configure_its_sites_from_empty_settings()
    {
        $settings = new JsonSettings([]);
        $settings->configureSites('test.com', 'test-com');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => 'test.com.test',
            'to' => '/home/vagrant/test-com/public',
        ], $attributes['sites'][0]);
    }

    /** @test */
    public function it_can_configure_its_shared_folders_from_existing_settings()
    {
        $settings = new JsonSettings([
            'folders' => [
                [
                    'map' => '~/code',
                    'to' => '/home/vagrant/code',
                    'type' => 'nfs',
                ],
            ],
        ]);

        $settings->configureSharedFolders('/a/path/for/project_name', 'project_name');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => '/a/path/for/project_name',
            'to' => '/home/vagrant/code',
            'type' => 'nfs',
        ], $attributes['folders'][0]);
    }

    /** @test */
    public function it_can_configure_its_shared_folders_from_empty_settings()
    {
        $settings = new JsonSettings([]);

        $settings->configureSharedFolders('/a/path/for/project_name', 'project_name');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => '/a/path/for/project_name',
            'to' => '/home/vagrant/project_name',
        ], $attributes['folders'][0]);
    }
}
