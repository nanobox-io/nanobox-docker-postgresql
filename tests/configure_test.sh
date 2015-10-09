#!/bin/bash
. `dirname $0`/util/bash_help.sh

UUID=$(cat /proc/sys/kernel/random/uuid)
pass "unable to start the container" docker run -d --name $UUID nanobox-io/nanobox-docker-postgresql
defer docker kill $UUID

# we should be able to run the configure hook
pass "unable to run configure hook" /opt/bin/default-configure '{}'