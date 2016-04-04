#!/bin/bash
#
# Run an individual test.
#
# $1 = test
#
# Example: ./run.sh lib/general_test.bats

file=$1
memcached_version=$2
test_dir="$(dirname $(readlink -f $BASH_SOURCE))"
tests_dir="${test_dir}/tests"
hookit_dir="$(dirname ${test_dir})/hookit"

# Ensure an argument was provided
if [[ $# -lt 1 ]]; then
  echo "Fatal: Must provide a test file as an argument"
  exit 1
fi

# Ensure the argument provided is a path to a file
if [[ ! -f ${tests_dir}/${file} ]]; then
  echo "Fatal: Test provided does not exist in tests (${file})"
  exit 1
fi

# Ensure the test is a .bats test file
filename=$(basename "${file}")
extension="${filename##*.}"

if [[ ! "$extension" = "bats" ]]; then
  echo "Fatal: Test provided is not a bats file (${file})"
  exit 1
fi

# Ensure a version was provided
if [[ -z "$memcached_version" ]]; then
  echo "Fatal: Memcached version must be specified as the second argument"
  exit 1
fi

echo "+> Running test ${file}:"

cd $test_dir

VERSION=$memcached_version \
${test_dir}/util/bats/bin/bats \
  ${tests_dir}/${file} \
    2>&1 \
      | (grep '\S' || echo "") \
        | sed -e 's/\r//g;s/^/   /'

# test the exit code
if [[ "${PIPESTATUS[0]}" != "0" ]]; then
  echo "   [!] FAILED"
  exit 1
else
  echo "   [√] SUCCESS"
fi
