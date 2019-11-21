# -*- mode: Dockerfile; tab-width: 4;indent-tabs-mode: nil;-*-
# vim: ts=4 sw=4 ft=Dockerfile et: 1
FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano

# Install arping
RUN apt-get update -qq && \
    apt-get install -y iputils-arping cron && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

USER gonano

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in \
        postgresql10-client \
        postgresql10-contrib \
        postgresql10-pgroonga \
        postgresql10-plperl \
        postgresql10-plpython \
        postgresql10-pltcl \
        postgresql10-postgis \
        postgresql10-server && \
    rm -rf /data/var/db/pkgin/cache

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
      https://s3.amazonaws.com/tools.nanobox.io/hooks/postgresql-stable.tgz \
        | tar -xz -C /opt/nanobox/hooks && \
    curl \
      -f \
      -k \
      -o /var/nanobox/hooks.md5 \
      https://s3.amazonaws.com/tools.nanobox.io/hooks/postgresql-stable.md5

# Cleanup disk
RUN rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

WORKDIR /data

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]
