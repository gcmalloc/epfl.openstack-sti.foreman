#!/bin/sh

# Usage:
# wget -O - https://raw.githubusercontent.com/domq/epfl.openstack-sti.foreman/master/run.sh  | bash
#
# Please keep this script:
#  * repeatable: it should be okay to run it twice
#  * readable (with comments in english)
#  * minimalistic: complicated things should be done with Puppet instead

set -e -x

rpm -q epel-release-6-8 || \
  rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -qa | grep puppetlabs-release || \
  rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

which foreman-installer || {
    # TODO: this is currently untested.
    yum-config-manager --enable rhel-6-server-optional-rpms rhel-server-rhscl-6-rpms
    yum -y install http://yum.theforeman.org/releases/1.7/el6/x86_64/foreman-release.rpm
}
 
# The : ${foo:=bar} mantra keeps foo from the environment, with bar as
# the default value.
: ${OPENSTACK_STIIT_INTERNAL_IFACE:=eth1}
# TODO: ask user with sane defaults from parsing ifconfig or something.
: ${OPENSTACK_STIIT_IPADDRESS=192.168.10.1}
: ${OPENSTACK_STIIT_DHCP_RANGE="192.168.10.32 192.168.10.127"}
: ${OPENSTACK_STIIT_CLUSTER_DOMAIN=epfl.ch}

foreman-installer \
  --enable-foreman-plugin-discovery \
  --foreman-plugin-discovery-install-images=true \
  --enable-foreman-proxy \
  --foreman-proxy-tftp=true \
  --foreman-proxy-tftp-servername="$OPENSTACK_STIIT_IPADDRESS" \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth1 \
  --foreman-proxy-dhcp-gateway="$OPENSTACK_STIIT_IPADDRESS" \
  --foreman-proxy-dhcp-range="$OPENSTACK_STIIT_DHCP_RANGE" \
  --foreman-proxy-dhcp-nameservers="$OPENSTACK_STIIT_IPADDRESS" \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface="$OPENSTACK_STIIT_INTERNAL_IFACE" \
  --foreman-proxy-dns-zone="$OPENSTACK_STIIT_CLUSTER_DOMAIN" \
  --foreman-proxy-dns-reverse=10.168.192.in-addr.arpa \
  --foreman-proxy-dns-forwarders=128.178.15.228 \
  --foreman-proxy-dns-forwarders=128.178.15.227 \
  --foreman-proxy-foreman-base-url=https://ostest1.epfl.ch

# TODO: somehow set up --foreman-proxy-oauth-consumer-key and
#                      --foreman-proxy-oauth-consumer-secret

set
echo "Congratulations!!!!!!!!"
