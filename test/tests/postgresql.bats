# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container "postgesql-test"
}

@test "Verify postgesql installed" {
  # ensure postgesql executable exists
  run docker exec "postgesql-test" bash -c "[ -f /data/bin/postgres ]"

  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container "postgesql-test"
}
