#!/bin/bash
for VERSION in $@; do
  # publishing doesn't quite work yet
  # docker build -t nanobox/nanobox-docker-postgresql:$VERSION -f Dockerfile-$VERSION .
done