# source docker helpers
. util/docker.sh

echo_lines() {
  for (( i=0; i < ${#lines[*]}; i++ ))
  do
    echo ${lines[$i]}
  done
}

@test "Start Container" {
  start_container "hooks-test"
}

@test "Verify hooks installed" {
  # look for a hook that should be there
  run docker exec "hooks-test" bash -c "ls /opt/nanobox/hooks/"
  echo_lines
  run docker exec "hooks-test" bash -c "ls /opt/nanobox/"
  echo_lines
  run docker exec "hooks-test" bash -c "ls /opt/"
  echo_lines
  run docker exec "hooks-test" bash -c "[ -f /opt/nanobox/hooks/configure ]"
  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container "hooks-test"
}
