# -*- mode: Dockerfile; tab-width: 4;indent-tabs-mode: nil;-*-
# vim: ts=4 sw=4 ft=Dockerfile et: 1
FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/
ADD files/. /

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in \
        postgresql93-client && \
    rm -rf /data/var/db/pkgin/cache

# Install binaries
RUN rm -rf /data/var/db/pkgin && \
    /data/bin/pkgin -y up && \
    /data/bin/pkgin -y in \
        luvit-0.10.0 \
        flip \
        flip-scripts \
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

# Cleanup disk
RUN rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]
