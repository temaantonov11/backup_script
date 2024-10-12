#!/bin/bash

folder_path="$1"


dd if=/dev/zero of=pattern.fs bs=1G count=2
sudo mkfs.ext4 pattern.fs
sudo mount -o users,rw -t ext4 pattern.fs "$folder_path"
sudo chmod a+rwx "$folder_path"
rm pattern.fs
