#!/bin/bash
FAILED=0
for file in `find . -type f -name '*_test.*'`; do
  echo running $file
  $file $@ | awk '{print " "$0}'
  if [ "${PIPESTATUS[0]}" != "0" ]; then
    echo test "$file" failed to run correctly
    let FAILED=FAILED+1
  fi
done

if [ "$FAILED" == "0" ]; then
  echo "all tests passed"
  exit 0
else
  echo "$FAILED test failed to run"
  exit 1
fi
