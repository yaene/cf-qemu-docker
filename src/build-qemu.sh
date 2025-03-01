#!/usr/bin/env bash

mkdir -p /qemu/build
cd /qemu/build
/tmp/qemu/configure
make -j$(nproc)
