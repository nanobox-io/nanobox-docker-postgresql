FROM nanobox/base

# Create directories
RUN mkdir -p /var/log/gonano

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/

RUN curl -s http://pkgsrc.nanobox.io/nanobox/base/Linux/bootstrap.tar.gz | tar -C / -zxf -
RUN echo "http://pkgsrc.nanobox.io/nanobox/base/Linux/" > /data/etc/pkgin/repositories.conf
RUN mkdir -p /data/var/db
RUN /data/sbin/pkg_admin rebuild
RUN rm -rf /data/var/db/pkgin && /data/bin/pkgin -y up
RUN /data/bin/pkgin -y in postgresql94-server # postgresql94-datatypes postgresql94-fuzzystrmatch postgresql94-pgcrypto

# Cleanup disk
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /data/var/db/pkgin

# Allow ssh
EXPOSE 22

# Run runit automatically
CMD /sbin/my_init
