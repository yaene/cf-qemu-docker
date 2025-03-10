ARG QEMU_BUILD=default

FROM ubuntu:24.04 AS common

# install dependencies for cuttlefish
RUN apt update && \
    apt upgrade -y && \
    apt install -y bridge-utils git devscripts equivs config-package-dev debhelper-compat \
        procps iptables iproute2 dnsmasq net-tools ca-certificates golang \
        curl wget sudo qemu-utils qemu-system-x86 && \
    wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    apt install ./libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    rm ./libtinfo5_6.3-2ubuntu0.1_amd64.deb

RUN update-ca-certificates

WORKDIR /root

# install cuttlefish
RUN git clone https://github.com/google/android-cuttlefish && \
    cd android-cuttlefish && \
    tools/buildutils/build_packages.sh && \
    dpkg -i ./cuttlefish-base_*_*64.deb || apt install -y -f && \
    dpkg -i ./cuttlefish-user_*_*64.deb || apt install -y -f 

RUN groupadd kvm && usermod -aG kvm root
RUN usermod -aG cvdnetwork root


FROM common AS qemu_custom
ENV QEMU_SRCDIR=/qemu
COPY --chmod=755 ./src/build-qemu.sh /run/
# install dependencies for qemu
RUN cat <<END >> /etc/apt/sources.list.d/ubuntu.sources 
Types: deb-src 
URIs: http://us.archive.ubuntu.com/ubuntu/ 
Suites: noble noble-updates noble-backports noble-proposed 
Components: main restricted universe multiverse 
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg 
END
RUN apt update && apt -y build-dep qemu
RUN --mount=type=bind,source=qemu,target=/tmp/qemu,ro \
  /run/build-qemu.sh
FROM common AS qemu_default

FROM qemu_${QEMU_BUILD}
COPY --chmod=755 ./src/qemu-system-aarch64 /run/
COPY --chmod=755 ./src/qemu-system-x86_64 /run/
COPY --chmod=755 ./src/entry.sh /run/
ENTRYPOINT ["/run/entry.sh"]

