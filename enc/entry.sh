#!/bin/bash

set -oxue pipefail

openssl enc -aes-256-cbc -d -pbkdf2 -pass file:/run/secrets/run-password -in /enc/image.squashfs.enc -out /enc/image.squashfs
rm -f /enc/image.squashfs.enc

mkdir -p /enc/newroot
mount -t squashfs /enc/image.squashfs /enc/newroot

mkdir -p /enc/oldroot
mount -o bind / /enc/oldroot

mkdir -p /enc/tmproot
mount -t tmpfs tmpfs /enc/tmproot

mkdir -p /enc/tmproot/{upper,work,overlay}
mount -t overlay -o rw,upperdir=/enc/tmproot/upper,workdir=/enc/tmproot/work,lowerdir=/enc/newroot:/enc/oldroot overlay /enc/tmproot/overlay

exec switch_root /enc/tmproot/overlay /enc/main.sh
