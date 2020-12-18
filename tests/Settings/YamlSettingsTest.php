<?php

namespace Tests\Settings;

use DMS\PHPUnitExtensions\ArraySubset\ArraySubsetAsserts;
use Laravel\Homestead\Settings\YamlSettings;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Yaml\Yaml;
use Tests\Traits\GeneratesTestDirectory;

class YamlSettingsTest extends TestCase
{
    use ArraySubsetAsserts, GeneratesTestDirectory;

    /** @test */
    public function it_can_be_created_from_a_filename()
    {
        $settings = YamlSettings::fromFile(__DIR__.'/../../resources/Homestead.yaml');

        self::assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '2',
        ], $settings->toArray());
    }

    /** @test */
    public function it_can_be_saved_to_a_file()
    {
        $settings = new YamlSettings([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => 1,
        ]);
        $filename = self::$testDirectory.DIRECTORY_SEPARATOR.'Homestead.yaml';

        $settings->save($filename);

        $this->assertFileExists($filename);
        self::assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '1',
        ], Yaml::parse(file_get_contents($filename)));
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

        self::assertArraySubset([
            'ip' => '127.0.0.1',
            'memory' => '4096',
            'cpus' => '2',
        ], $settings->toArray());
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

        self::assertArraySubset([
            'ip' => '192.168.10.10',
            'memory' => '2048',
            'cpus' => '1',
        ], $settings->toArray());
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
    public function it_can_configure_its_sites_from_existing_settings()
    {
        $settings = new YamlSettings([
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
        $settings = new YamlSettings([]);
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
        $settings = new YamlSettings([
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
        $settings = new YamlSettings([]);

        $settings->configureSharedFolders('/a/path/for/project_name', 'project_name');

        $attributes = $settings->toArray();
        $this->assertEquals([
            'map' => '/a/path/for/project_name',
            'to' => '/home/vagrant/project_name',
        ], $attributes['folders'][0]);
    }
}
