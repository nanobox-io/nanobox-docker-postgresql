#!/bin/bash
for VERSION in $@; do
  docker build -t nanobox/nanobox-docker-postgresql:$VERSION -f Dockerfile-$VERSION .
done