all: image

image:
ifdef docker_user
	vagrant up
else
	export docker_user='nanobox' && vagrant up
endif

publish:
ifdef docker_user
	vagrant provision
else
	export docker_user='nanobox' && vagrant provision
endif

push_94_stable:
	vagrant ssh -c "sudo docker push nanobox/postgresql"
	vagrant ssh -c "sudo docker push nanobox/postgresql:9.4"
	vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-stable"

push_94_beta:
	vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-beta"

push_94_alpha:
	vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-alpha"

clean:
	vagrant destroy -f
