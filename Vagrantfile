require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"
confDir = $confDir ||= File.expand_path("~/.homestead")

homesteadYamlPath = confDir + "/Homestead.yaml"
afterScriptPath = confDir + "/after.sh"
afterRubyPath = "after.rb"
aliasesPath = confDir + "/aliases"

require File.expand_path(File.dirname(__FILE__) + '/scripts/homestead.rb')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	if File.exists? aliasesPath then
		config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
	end

	Homestead.configure(config, YAML::load(File.read(homesteadYamlPath)))

	if File.exists? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath
	end

    if File.exists? afterRubyPath then
        require File.expand_path(afterRubyPath)
        HomesteadAfter.processing(config, YAML::load(File.read(homesteadYamlPath)))
    end
end
