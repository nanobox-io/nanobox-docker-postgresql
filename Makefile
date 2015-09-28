all: build publish

LATEST:=9.4
stability?=latest
version?=$(LATEST)
dockerfile?=Dockerfile-$(version)

login:
	@vagrant ssh -c "docker login"

build:
	@echo "Building 'postgresql' image..."
	@vagrant ssh -c "docker build -f /vagrant/Dockerfile-${version} -t nanobox/postgresql /vagrant"

publish:
	@echo "Tagging 'postgresql:${version}-${stability}' image..."
	@vagrant ssh -c "docker tag -f nanobox/postgresql nanobox/postgresql:${version}-${stability}"
	@echo "Publishing 'postgresql:${version}-${stability}'..."
	@vagrant ssh -c "docker push nanobox/postgresql:${version}-${stability}"
ifeq ($(version),$(LATEST))
	@echo "Publishing 'postgresql:${stability}'..."
	@vagrant ssh -c "docker tag -f nanobox/postgresql nanobox/postgresql:${stability}"
	@vagrant ssh -c "docker push nanobox/postgresql:${stability}"
endif

clean:
	@echo "Removing all images..."
	@vagrant ssh -c "for image in \$$(docker images -q); do docker rmi -f \$$image; done"