FROM ubuntu:20.04 as ovs-debs

# Install dependencies for building OVS deb packages
# We only install python3 packages and we only support building OVS >= 2.13.0.
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends wget curl git ca-certificates build-essential fakeroot graphviz \
            bzip2 autoconf automake debhelper dh-python dh-autoreconf libssl-dev libtool openssl procps \
            python3-all python3-twisted python3-zope.interface python3-sphinx \
            libunbound-dev bc libjemalloc2 libjemalloc-dev llvm-dev libelf-dev libnuma-dev libpcap-dev selinux-policy-dev ncat
WORKDIR /tmp
RUN git clone -b v21.06.0 https://github.com/ovn-org/ovn.git
RUN cd ovn && ./boot.sh && git submodule update --init

RUN cd /tmp/ovn/ovs && ./boot.sh && ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc && \
    DEB_BUILD_OPTIONS='parallel=4 nocheck' fakeroot debian/rules binary && \
    cd /tmp/ovn && mkdir /tmp/ovs-debs && mv libopenvswitch_*.deb openvswitch-common_*.deb openvswitch-switch_*.deb python*-openvswitch_*.deb \
       openvswitch-ipsec_*.deb /tmp/ovs-debs/


FROM ubuntu:20.04 as ovn-debs

# Install dependencies for building OVS deb packages
# We only install python3 packages and we only support building OVS >= 2.13.0.
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends wget curl git ca-certificates build-essential fakeroot graphviz \
            bzip2 autoconf automake debhelper dh-python dh-autoreconf libssl-dev libtool openssl procps \
            python3-all python3-twisted python3-zope.interface python3-sphinx \
            libunbound-dev bc libjemalloc2 libjemalloc-dev llvm-dev libelf-dev libnuma-dev libpcap-dev selinux-policy-dev ncat
WORKDIR /tmp
RUN git clone -b v21.06.0 https://github.com/ovn-org/ovn.git
RUN cd ovn && ./boot.sh && git submodule update --init
RUN cd /tmp/ovn/ovs && ./boot.sh && ./configure && \
    make -j4 && make install
RUN cd ovn && ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc && DEB_BUILD_OPTIONS='parallel=4 nocheck' fakeroot debian/rules -e OVSDIR=/tmp/ovn/ovs binary && \
    mkdir /tmp/ovn-debs && mv /tmp/*.deb /tmp/ovn-debs


FROM ubuntu:20.04

COPY --from=ovs-debs /tmp/ovs-debs/* /tmp/ovs-debs/
COPY --from=ovn-debs /tmp/ovn-debs/* /tmp/ovn-debs/

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    iproute2 curl tcpdump iputils-ping isc-dhcp-client netperf vim iptables
RUN (dpkg -i /tmp/ovs-debs/* || apt-get -f -y --no-install-recommends install)&& dpkg -i /tmp/ovn-debs/* && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && rm -r /tmp/*
COPY scripts/* /usr/local/bin/
