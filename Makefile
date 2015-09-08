image:
	@vagrant up
	@vagrant ssh -c "sudo docker build -t nanobox/postgresql /vagrant"

# image_93:
# 	@vagrant up
# 	@vagrant ssh -c "sudo docker build -t nanobox/postgresql:9.3 -f Dockerfile-9_3 /vagrant"

tag:
	@vagrant ssh -c "sudo docker tag nanobox/postgresql nanobox/postgresql:9.4"
	@vagrant ssh -c "sudo docker tag nanobox/postgresql nanobox/postgresql:9.4-stable"
	@vagrant ssh -c "sudo docker tag nanobox/postgresql nanobox/postgresql:9.4-beta"
	@vagrant ssh -c "sudo docker tag nanobox/postgresql nanobox/postgresql:9.4-alpha"

all: image tag

publish:
	@vagrant ssh -c "sudo docker push nanobox/postgresql"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-stable"

push_94_stable:
	@vagrant ssh -c "sudo docker push nanobox/postgresql"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-stable"

push_94_beta:
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-beta"

push_94_alpha:
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-alpha"

clean:
	@vagrant destroy -f
