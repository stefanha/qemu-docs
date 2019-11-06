#!/bin/bash
set -e

# Grab the latest qemu.git commits
cd qemu
git pull origin

# Rebuild documentation
rm -rf install-dir
mkdir install-dir
./configure --prefix=$PWD/install-dir
make install-doc

# Upload patches metadata to HTTP server
rsync -ac install-dir/share/doc/qemu qemu.org:public
