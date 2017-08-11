# -*- mode: ruby -*-
# vi: set ft=ruby :

#
## Set global output colors
#
NC = "\033[0m"
RED = "\033[0;31m"
GREEN = "\033[0;32m"

require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

homesteadYamlPath = File.join(confDir, "files", "Homestead.yaml")
homesteadJsonPath = File.join(confDir, "files", "Homestead.json")
afterScriptPath = File.join(confDir, "files", "after.sh")
aliasesPath = File.join(confDir, "files", "aliases")

# Custom resources
customResources = Dir[File.join(confDir, "files", "custom", "*")]

require File.expand_path(File.dirname(__FILE__) + '/scripts/homestead.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exist? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
        config.vm.provision "shell" do |s|
            s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
        end
    end

    # Provision all the custom files in guest's "/tmp"
    puts 'Provision all the custom files in guest\'s "/tmp"...'

    customResources.each { |filepath|
        if File.exist? filepath then
            filename = File.basename filepath
            config.vm.provision "file", source: filepath, destination: "/tmp/" + filename
            puts '  * Provisioned file "' + filename + '"'
        else
            puts RED + '  * ERROR: Cannot provision file because file "' + filename + '" doesn\'t exist' + NC
        end
    }
    puts GREEN + '  > done' + NC

    # Map ports for XDebug
    config.vm.network "forwarded_port", guest: 9000, host: 9000, protocol: "TCP", auto_correct: true

    # Map ports for ElasticSearch
    config.vm.network "forwarded_port", guest: 9200, host: 9200, protocol: "TCP", auto_correct: true

    if File.exist? homesteadYamlPath then
        settings = YAML::load(File.read(homesteadYamlPath))
    elsif File.exist? homesteadJsonPath then
        settings = JSON.parse(File.read(homesteadJsonPath))
    else
        abort "Homestead settings file not found in #{confDir}"
    end

    Homestead.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: true
    end

    if defined? VagrantPlugins::HostsUpdater
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    end
end
