#!/bin/bash
. `dirname $0`/util/bash_help.sh

pass "unable to start the container" docker run -d --name $0 nanobox-io/nanobox-docker-postgresql
defer docker kill $0

# we should be able to run the configure hook
pass "unable to run configure hook" /opt/bin/default-configure '{}'