# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 1536
    v.cpus = 2
  end
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "14.04"
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "192.168.33.12"
  config.vm.synced_folder "html", "/var/www/html", create: true,
    owner: "www-data",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]
  config.vm.provision :shell, :path => "conf/provision.sh"
end
