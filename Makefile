image:
	@vagrant up
	@vagrant ssh -c "sudo docker build -t nanobox/postgresql /vagrant"

# image_93:
# 	@vagrant up
# 	@vagrant ssh -c "sudo docker build -t nanobox/postgresql:9.3 -f Dockerfile-9_3 /vagrant"

tag:
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:9.4"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:9.4-stable"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:9.4-beta"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:9.4-alpha"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:stable"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:beta"
	@vagrant ssh -c "sudo docker tag -f nanobox/postgresql nanobox/postgresql:alpha"

all: image tag

publish: push_94_stable

push_94_stable: push_94_beta
	@vagrant ssh -c "sudo docker push nanobox/postgresql"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-stable"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:stable"

push_94_beta: push_94_alpha
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-beta"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:beta"

push_94_alpha:
	@vagrant ssh -c "sudo docker push nanobox/postgresql:9.4-alpha"
	@vagrant ssh -c "sudo docker push nanobox/postgresql:alpha"

clean:
	@vagrant destroy -f
