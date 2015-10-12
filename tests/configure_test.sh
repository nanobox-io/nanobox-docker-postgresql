#!/bin/bash
. `dirname $0`/util/bash_help.sh

UUID=$(cat /proc/sys/kernel/random/uuid)
pass "unable to start the container" docker run --privileged=true -d --name $UUID nanobox-io/nanobox-docker-postgresql
defer docker kill $UUID

# we should be able to run the basic configure hook
BOXFILE='{"platform" : "local","boxfile" : {"locale": "EN"},"uid":"$UUID","logtap_host":"127.0.0.1"}'
echo boxfile: "$BOXFILE"
pass "configure hook works correctly" docker exec $UUID /opt/bin/default-configure "$BOXFILE"