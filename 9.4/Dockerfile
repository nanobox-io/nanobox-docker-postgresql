# -*- mode: Dockerfile; tab-width: 4;indent-tabs-mode: nil;-*-
# vim: ts=4 sw=4 ft=Dockerfile et: 1
FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano

# Install arping
RUN apt-get update -qq && \
    apt-get install -y iputils-arping && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in perl-5.24 postgresql94-client && \
    /data/bin/pkgin -y in \
        yoke \
        postgresql94-adminpack \
        postgresql94-contrib \
        postgresql94-datatypes \
        postgresql94-dblink \
        postgresql94-fuzzystrmatch \
        postgresql94-monitoring \
        postgresql94-pgcrypto \
        postgresql94-plperl \
        postgresql94-plpython \
        postgresql94-pltcl \
        postgresql94-replicationtools \
        postgresql94-server \
        postgresql94-upgrade && \
    rm -rf /data/var/db/pkgin/cache

# Install yoke scripts
ADD files/. /

RUN rm -rf /var/gonano/db/pkgin && \
    /opt/gonano/bin/pkgin -y up && \
    /opt/gonano/bin/pkgin -y in \
        rsync && \
    rm -rf /var/gonano/db/pkgin/cache

# Install hooks
RUN mkdir -p /opt/nanobox/hooks && \
    mkdir -p /var/nanobox && \
    curl \
      -f \
      -k \
      https://d1ormdui8qdvue.cloudfront.net/hooks/postgresql-stable.tgz \
        | tar -xz -C /opt/nanobox/hooks && \
    curl \
      -f \
      -k \
      -o /var/nanobox/hooks.md5 \
      https://d1ormdui8qdvue.cloudfront.net/hooks/postgresql-stable.md5

# Cleanup disk
RUN rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]
