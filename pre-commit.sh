#!/bin/bash
# copy common files to version directories
rsync -a files/. 9.3/files
rsync -a hookit/. 9.3/hookit
git add 9.3 --all

rsync -a files/. 9.4/files
rsync -a hookit/. 9.4/hookit
git add 9.4 --all
