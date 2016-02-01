VERSION=$1
echo running tests for $VERSION of postgresql
UUID=$(cat /proc/sys/kernel/random/uuid)
PAYLOAD='{"boxfile":{"name":"database1","stability":"stable","version":'${VERSION}'},"logtap_host":"127.0.0.1","platform":"local","uid":"postgresql1"}'
echo boxfile: "$PAYLOAD"

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/nanobox-docker-postgresql:$VERSION
defer docker kill $UUID

# we should be able to run the basic update hook
pass "unable to run the update hook for $VERSION" docker exec $UUID /opt/bin/update "$PAYLOAD"

# we should be able to run the basic configure hook
pass "unable to run the configure hook for $VERSION" docker exec $UUID /opt/bin/default-configure "$PAYLOAD"

# now we just need to verify that changes were atually made correctly.