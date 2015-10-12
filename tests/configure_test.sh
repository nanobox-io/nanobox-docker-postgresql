UUID=$(cat /proc/sys/kernel/random/uuid)
pass "unable to start the container" docker run --privileged=true -d --name $UUID nanobox-io/nanobox-docker-postgresql
defer docker kill $UUID

# we should be able to run the basic configure hook
BOXFILE='{"platform":"local","boxfile":{"locale":"en_US.UTF-8"},"uid":"$UUID","logtap_host":"127.0.0.1"}'
echo boxfile: "$BOXFILE"
pass "unable to run the configure hook" docker exec $UUID /opt/bin/default-configure "$BOXFILE"