#!/bin/bash

# Populate git repository on first run
if [ ! -d qemu ]; then
	git clone https://git.qemu.org/git/qemu.git
fi

while true; do
	echo "Updating docs at $(date)..."
	./update-docs.sh
	echo "done"
	sleep 1d
done
