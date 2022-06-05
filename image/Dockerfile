FROM ubuntu:22.04

COPY image/sources.list /etc/apt/

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    ovn-common ovn-host ovn-central openvswitch-vtep logrotate iptables iproute2 curl tcpdump tshark \
    iperf3 iputils-ping isc-dhcp-client vim netcat

COPY scripts/* /usr/local/bin/
