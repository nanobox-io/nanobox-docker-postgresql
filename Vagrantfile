# -*- mode: ruby -*-
# vi: set ft=ruby :

latest = `curl -s https://api.github.com/repos/pagodabox/nanobox-boot2docker/releases/latest | json name`.strip

$wait = <<SCRIPT
echo "Waiting for docker sock file"
while [ ! -S /var/run/docker.sock ]; do
  sleep 1
done
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box     = "nanobox/boot2docker"
  config.vm.box_url = "https://github.com/pagodabox/nanobox-boot2docker/releases/download/#{latest}/nanobox-boot2docker.box"

  config.vm.synced_folder ".", "/vagrant"

  # wait for docker to be running
  config.vm.provision "shell", inline: $wait

  # Add docker credentials
  config.vm.provision "file", source: "~/.dockercfg", destination: "/root/.dockercfg"

  # Build image
  config.vm.provision "shell", inline: "docker build -t #{ENV['docker_user']}/postgresql /vagrant"
  # config.vm.provision "shell", inline: "docker build -t #{ENV['docker_user']}/postgresql:9.3 -f Dockerfile-9_3 /vagrant"

  # Tag built images
  config.vm.provision "shell", inline: "docker tag #{ENV['docker_user']}/postgresql #{ENV['docker_user']}/postgresql:9.4"
  config.vm.provision "shell", inline: "docker tag #{ENV['docker_user']}/postgresql #{ENV['docker_user']}/postgresql:9.4-stable"

  # Publish image to dockerhub
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/postgresql"
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/postgresql:9.4"
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/postgresql:9.4-stable"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

end
