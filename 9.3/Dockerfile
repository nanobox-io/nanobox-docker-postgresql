# -*- mode: Dockerfile; tab-width: 4;indent-tabs-mode: nil;-*-
# vim: ts=4 sw=4 ft=Dockerfile et: 1
FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano

# Install binaries
# RUN rm -rf /data/var/db/pkgin && \
#     /data/bin/pkgin -y up && \
#     /data/bin/pkgin -y in \
#         postgresql93-client && \
#     rm -rf /data/var/db/pkgin/cache

# Install arping
RUN apt-get update -qq && \
    apt-get install -y iputils-arping cron && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

USER gonano

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in perl-5.24 postgresql93-client && \
    /data/bin/pkgin -y in \
        yoke \
        postgresql93-adminpack \
        postgresql93-contrib \
        postgresql93-datatypes \
        postgresql93-dblink \
        postgresql93-fuzzystrmatch \
        postgresql93-monitoring \
        postgresql93-pgcrypto \
        postgresql93-plperl \
        postgresql93-plpython \
        postgresql93-pltcl \
        postgresql93-replicationtools \
        postgresql93-server \
        postgresql93-upgrade && \
    rm -rf /data/var/db/pkgin/cache

# Install yoke scripts
ADD files/. /

USER root

RUN rm -rf /var/gonano/db/pkgin && \
    /opt/gonano/bin/pkgin -y up && \
    /opt/gonano/bin/pkgin -y in \
        rsync && \
    rm -rf /var/gonano/db/pkgin/cache

RUN /opt/gonano/bin/gem install remote_syslog_logger

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
