require "json"
require "yaml"

VAGRANT_VERSION = 2
CONF_DIR = $CONF_DIR ||= File.expand_path("~/.homestead")

homesteadYamlPath = CONF_DIR + "/Homestead.yaml"
homesteadJsonPath = CONF_DIR + "/Homestead.json"
afterScriptPath = CONF_DIR + "/after.sh"
aliasesPath = CONF_DIR + "/aliases"

require File.expand_path(File.dirname(__FILE__) + "/scripts/homestead.rb")

Vagrant.configure(VAGRANT_VERSION) do |config|
    if File.exists? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
    end

    if File.exists? homesteadYamlPath then
        Homestead.configure(config, YAML::load(File.read(homesteadYamlPath)))
    elsif File.exists? homesteadJsonPath then
        Homestead.configure(config, JSON.parse(File.read(homesteadJsonPath)))
    end

    if File.exists? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath
    end
end
