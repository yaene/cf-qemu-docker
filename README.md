# Docker Container for Cuttlefish-Qemu

I wanted to use cuttlefish with qemu on a non-debian device.
The [provided docker container](https://github.com/google/android-cuttlefish/tree/main/docker)
did not work for me as expected and includes more than I needed (cloud-orchestration packages).
It also only seems to support CrosVM (dont quote me on this).
If the google-provided docker container works for you please use that instead.

# How to Use

## Build docker container

```bash
docker build -t cuttlefish-qemu .
```

## Run Docker container

Prerequisite is to create a folder with the cuttlefish device images and host-
package as described in the
[android documentation](https://source.android.com/docs/devices/cuttlefish/get-started).

```bash
docker run --volume <path-to-cuttlefish-folder>:/root/cuttlefish --privileged -p 6520:6520 cuttlefish-qemu
```

## Connect to device with ADB

```bash
# connect to adb server in container
adb connect localhost:6520
# now adb commands will find the device
adb devices # should see cuttlefish device
```

## Use custom qemu build

You can use a custom qemu build by attaching a volume of the directory, and
providing the path to it in the `QEMU_BINDIR` variable

```bash
docker run -v <path-to-qemu-dir>:/qemu -e "QEMU_BINDIR=/qemu"
```

# Common Issues

You may need to install the iptables kernel module manually on your host,
as it is normally lazily loaded and may not be available in the container.

```bash
modprobe ip_tables
```

Build may fail when building cvd with bazel, due to some network timeouts.
Running the build with `--network=host` may help.

```bash
docker build --network=host -t cuttlefish .
```

# Limitations

- not documented how to avoid --privileged flag (which exact capabilities are necessary)
- custom qemu build not supported yet
- no graphical interface supported yet
