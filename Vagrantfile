# frozen_string_literal: true
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

MEMORY_IN_GB = 4.freeze
DISK_IN_GB = 40.freeze
MACHINE_NAME = 'J-Quants-Tutorial'
CURRENT_PATH = Dir.pwd
HOME_PATH = '/home/vagrant'
J_QUANTS_DIR_NAME = 'J-Quants-Tutorial'
HANDSON_PATH = Pathname.new(HOME_PATH).join(J_QUANTS_DIR_NAME).join('handson').to_s
DOCKER_COMPOSE_VERSION = '1.28.2'
UBUNTU_VERSION = 'focal'  # Ubuntu 20.04 LTS

Vagrant.configure('2') do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/#{UBUNTU_VERSION}64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vbguest.auto_update = false
  config.vm.box_check_update = false
  #config.vbguest.no_remote = true

  config.disksize.size = "#{DISK_IN_GB}GB"


  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing 'localhost:8080' will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # 開放したいポートがあればここで宣言
  ports = {
    # ssh: 22, デフォルトでホストの2222番ポートはゲストの22番ポートにフォワードされるので、不要
    jupyter: 8888,
  }
  ports.each do |_service, port|
    config.vm.network 'forwarded_port', guest: port, host: port
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.define MACHINE_NAME do |server|
    server.vm.network 'private_network', ip: '192.168.33.10'
  end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network 'public_network'

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder(
    Pathname.new(CURRENT_PATH).join('J-Quants-Tutorial').to_s,
      "#{HOME_PATH}/J-Quants-Tutorial",
      mount_options: ['uid=1000,gid=1000'])
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = (1024 * MEMORY_IN_GB).to_s
    vb.name = MACHINE_NAME
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define 'atlas' do |push|
  #   push.app = 'YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME'
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # puts "Current dir: #{CURRENT_PATH}"
  files = {
    home_dir: { HOME_PATH => %w[.bashrc .bash_profile] },
    handson_dir: {
      Pathname.new(HOME_PATH).join('J-Quants-Tutorial').join('handson').to_s =>
        %w[Dockerfile docker-compose.yml] },
  }

  files.each do |_name, parent_file_pair|
    parent_file_pair.each do |parent, files|
      files.each do |filename|
        source = "#{CURRENT_PATH}/#{filename}"
        destination = Pathname.new(parent).join(filename).to_s
        # puts "Copy from #{source} to #{destination}"

        config.vm.provision('file',
          source: source, destination: destination)
      end
    end
  end

  config.vm.provision 'shell', inline: <<-SHELL
    # Exit if already bootstrapped
    test -f /etc/bootstrapped && exit

	  apt update
	  apt install -y apt-transport-https ca-certificates curl software-properties-common
	  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository \
     		'deb [arch=amd64] https://download.docker.com/linux/ubuntu #{UBUNTU_VERSION} stable'

    apt update
    apt install -y docker-ce direnv libssl-dev git screen gcc g++ make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev build-essential libstdc++6

    groupadd docker
    gpasswd -a vagrant docker
    service docker restart
    curl -L https://github.com/docker/compose/releases/download/#{DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

	  apt -y upgrade

    su - vagrant
    echo '################################'
    echo 'Build the Docker Image.'
    cd #{HANDSON_PATH} && docker-compose build && \
      docker -v && date > /etc/bootstrapped
  SHELL
end
