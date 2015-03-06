require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"

homesteadYamlPath = File.expand_path("~/.homestead/Homestead.yaml")
afterScriptPath = File.expand_path("~/.homestead/after.sh")
aliasesPath = File.expand_path("~/.homestead/aliases")

require_relative 'scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	if File.exists? aliasesPath then
		config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
	end

	Homestead.configure(config, YAML::load(File.read(homesteadYamlPath)))

	if File.exists? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath
	end
end
