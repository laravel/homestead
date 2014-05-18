VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require __dir__ + '/scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Homestead.configure(config, YAML::load(File.read(__dir__ + '/Homestead.yaml')))
end
