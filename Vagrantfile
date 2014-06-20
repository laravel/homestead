VAGRANTFILE_API_VERSION = "2"

path = "#{File.dirname(__FILE__)}"

require 'yaml'
require path + '/scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Homestead.configure(config, YAML::load(File.read(path + '/Homestead.yaml')))
  
  config.vm.network "forwarded_port", guest: 6379, host: 63790 # Redis forwarded from default port 6379 to port 63790.
  config.vm.network "forwarded_port", guest: 11211, host: 11212 # Memcached forwarded from default port 11211 to port 11212.
  
end
