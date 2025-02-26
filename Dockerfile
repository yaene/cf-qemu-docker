FROM ubuntu:24.04

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

RUN git clone https://github.com/google/android-cuttlefish && \
    cd android-cuttlefish && \
    tools/buildutils/build_packages.sh && \
    dpkg -i ./cuttlefish-base_*_*64.deb || apt install -y -f && \
    dpkg -i ./cuttlefish-user_*_*64.deb || apt install -y -f 

RUN groupadd kvm && usermod -aG kvm root
RUN usermod -aG cvdnetwork root

COPY --chmod=755 ./src /run/

ENTRYPOINT ["/run/entry.sh"]

