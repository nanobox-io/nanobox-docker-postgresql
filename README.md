nanobox postgresql
============

This repo contains the files necessary to create a code docker image for [nanobox](nanobox.io) consumption.


Requirements
------------

* `docker_user` environment variable `export docker_user='nanobox'`
* `~/.dockercfg` file with credentials for `docker_user`
* [vagrant](vagrantup.com)
* [dockerhub](hub.docker.com) account


Usage
-----

To create and publish the image to nanobox/postgresql simply run      
`make` or `vagrant up && vagrant destroy -f`    
If the creation/publication fails for any reason, you may       
modify the proper files and run `make publish` or `vagrant provision`    
        
To login to the zone:
```
user: gonano
pass: gonano
```
        
TIP: If you forget to create a `docker_user` environment variable,      
you can `vagrant ssh` and run `docker tag nanobox/postgresql ${YOUR_USER}/postgresql`      
then push with `docker push ${YOUR_USER}/postgresql`   


License
-------

Mozilla Public License, version 2.0
