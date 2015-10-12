#!/bin/bash
. `dirname $0`/util/bash_help.sh

UUID=$(cat /proc/sys/kernel/random/uuid)
pass "unable to start the container" docker run --privileged=true -d --name $UUID nanobox-io/nanobox-docker-postgresql
defer docker kill $UUID

docker exec $UUID ls /opt/gonano/bin/hookit
# we should be able to run the configure hook
docker exec $UUID /opt/bin/default-configure '{}'
echo $?