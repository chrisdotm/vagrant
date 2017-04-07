### Getting started
All my projects require the following vagrant plugins
* vagrant-puppet-install
* vagrant-vbguest

`vagrant plugin install [plugin-name]`


### paperwork

This Project isn't complete, dont even try

### rancher

Below are the steps to start using the Vagrantfile:
```
vagrant up
vangrant ssh
sudo reboot
vagrant ssh
docker run -d --restart=unless-stopped -p 8080:8080 rancher/server
```
