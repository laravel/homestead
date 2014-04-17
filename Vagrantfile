VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require './scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Homestead.configure(config, YAML::load(File.read('./Homestead.yaml')))
end
