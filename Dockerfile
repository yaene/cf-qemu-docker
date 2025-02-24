FROM ubuntu:24.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y git devscripts equivs config-package-dev debhelper-compat golang curl wget sudo && \
    wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    apt install ./libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    rm ./libtinfo5_6.3-2ubuntu0.1_amd64.deb

RUN git clone https://github.com/google/android-cuttlefish && \
    cd android-cuttlefish && \
    tools/buildutils/build_packages.sh && \
    dpkg -i ./cuttlefish-base_*_*64.deb || apt install -y -f && \
    dpkg -i ./cuttlefish-user_*_*64.deb || apt install -y -f 

