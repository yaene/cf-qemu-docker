#!/usr/bin/env bash
DEFAULT_CVD_ARGS="\
--vm_manager=qemu_cli \
--start_webrtc=false \
--report_anonymous_usage_stats=n \
"

: "${CF_HOME:=/cuttlefish}"
: "${CVD_ARGS:=$DEFAULT_CVD_ARGS}"
: "${EXTRA_CVD_ARGS:=}"
: "${DEBUG:="false"}"

info () { printf "%b%s%b" "\E[1;34m❯ \E[1;36m" "${1:-}" "\E[0m\n"; }
error () { printf "%b%s%b" "\E[1;31m❯ " "ERROR: ${1:-}" "\E[0m\n" >&2; }
warn () { printf "%b%s%b" "\E[1;31m❯ " "Warning: ${1:-}" "\E[0m\n" >&2; }

service cuttlefish-host-resources start

# setup host forwarding
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i cvd-ebr -o eth0 -j ACCEPT

if false; then
  HOME=$CF_HOME $CF_HOME/bin/launch_cvd \
    $CVD_ARGS \
    --qemu_binary_dir="/run" \
    $EXTRA_CVD_ARGS
else
  exec /bin/bash
fi
# 1981
