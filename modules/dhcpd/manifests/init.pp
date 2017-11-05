# Class: dhcpd
# ===========================
#
# Kevin's Puppet Module to configure a DHCP server.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `$dns_servers`
#   The DNS servers to set for DHCP clients configured in /etc/dhcpd.conf.
#
# * `$domain_name`
#   The domain name to set for DHCP clients configured in /etc/dhcpd.conf.
#
# * `$network`
#   The IP address groups to use for DHCP assignments configured in /etc/dhcpd.conf.
#
# * `$subnet`
#   The netmask to use for the IP address groups configured in /etc/dhcpd.conf.
#
# * `$router`
#   The router IP address to use for DHCP assignments configured in /etc/dhcpd.conf.
#
# * `$range`
#   The range of IP addresses to use for DHCP assignments configured in /etc/dhcpd.conf.
#
# * `$nodes`
#   The hosts and static IP addresses to use for DHCP assignments configured in /etc/dhcpd.conf.
#
# * `$time_offset`
#   The time zone offset in seconds.
#
# * `$eth_device`
#   The device used for the dhcpd service, configured in the dhcpd4@service.
#   This is the best way to control which device will try to serve DHCP clients,
#   and is needed when connected to multiple networks with other DHCP servers.
#
# Examples
# --------
#
# @example
#    node default {
#      include dhcpd
#    }
#
# Authors
# -------
#
# Kevin Ashcraft <kevin@kevashcraft.com>
#
# Copyright
# ---------
#
# Copyright 2017 Kevin Ashcraft MIT License
#
class dhcpd (
  $dns_servers,
  $domain_name,
  $network,
  $subnet,
  $router,
  $range,
  $nodes,
  $time_offset,
  $eth_device,
  ) {

  package { 'dhcp':
    ensure => installed,
  }

  file { '/etc/systemd/system/dhcpd4@.service':
    source  => 'puppet:///modules/dhcpd/dhcpd4@.service',
    require => Package['dhcp'],
  }

  service { "dhcpd4@${eth_device}":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File['Z/etc/systemd/system/dhcpd4@.service'],
  }

  file { '/etc/dhcpd.conf':
    content => template('dhcpd/dhcpd.conf.erb'),
    notify  => Service["dhcpd4@${eth_device}"]
  }
}