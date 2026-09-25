#!/bin/env sh

mkdir -p /var/tmp/nixos-vm 2>/dev/null
XDG_RUNTIME_DIR=/var/tmp/nixos-vm ./result/bin/nixos-test-driver
