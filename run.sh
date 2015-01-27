#!/bin/sh

# Usage:
# wget -O - https://raw.githubusercontent.com/domq/epfl.openstack-sti.foreman/master/run.sh  | bash
#
# Please keep this script:
#  * repeatable: it should be okay to run it twice
#  * readable (with comments in english)
#  * minimalistic: complicated things should be done with Puppet instead

: ${OPENSTACK_STIIT_INTERNAL_IFACE:=eth1}
# TODO: ask user with sane defaults from parsing ifconfig or something.
: ${OPENSTACK_STIIT_IPADDRESS=192.168.10.1}
: ${OPENSTACK_STIIT_DHCP_RANGE="192.168.10.32 192.168.10.127"}

false && foreman-installer \
  --enable-foreman-plugin-discovery \
  --foreman-plugin-discovery-install-images=true \
  --enable-foreman-proxy \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername=192.168.10.1 \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth1 \
  --foreman-proxy-dhcp-gateway=192.168.10.1 \
  --foreman-proxy-dhcp-range="192.168.10.32 192.168.10.127" \
  --foreman-proxy-dhcp-nameservers="192.168.10.1" \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface=eth1 \
  --foreman-proxy-dns-zone=epfl.ch \
  --foreman-proxy-dns-reverse=10.168.192.in-addr.arpa \
  --foreman-proxy-dns-forwarders=128.178.15.228 \
  --foreman-proxy-dns-forwarders=128.178.15.227 \
  --foreman-proxy-foreman-base-url=https://ostest1.epfl.ch

# TODO: somehow set up --foreman-proxy-oauth-consumer-key and
#                      --foreman-proxy-oauth-consumer-secret

set
echo "Congratulations!!!!!!!!"
