VAGRANTFILE_API_VERSION = "2"

require 'json'
require 'yaml'

config = JSON.parse(File.read("var/config.json"))
homesteadYamlPath = config["directory"] + "/Homestead.yaml"
afterScriptPath = config["directory"] + "/after.sh"

require_relative 'scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Homestead.configure(config, YAML::load(File.read(homesteadYamlPath)))

  if File.exists? afterScriptPath then
  	config.vm.provision "shell", path: afterScriptPath
  end
end
