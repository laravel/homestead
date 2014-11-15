VAGRANTFILE_API_VERSION = "2"

require 'json'
require 'yaml'

homesteadConfig = JSON.parse(File.read("var/config.json"))
homesteadYamlPath = homesteadConfig["directory"] + "/Homestead.yaml"
afterScriptPath = homesteadConfig["directory"] + "/after.sh"

require_relative 'scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	if File.exists? homesteadConfig["directory"] + "/aliases" then
		config.vm.provision "file", source: homesteadConfig["directory"] + "/aliases", destination: "~/.bash_aliases"
	end

	Homestead.configure(config, YAML::load(File.read(homesteadYamlPath)))

	if File.exists? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath
	end
end
