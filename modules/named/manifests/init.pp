# Class: named
# ===========================
#
# Kevin's Puppet Module for configuring DNS with named.
#
# Parameters
# ----------
#
# * `$forwarders`
#   The IP addresses used for forwarding unknown DNS requests, configured in /etc/named.conf.
#
# * `$server_ip`
#   The IP addressed used for serving DNS requests, configured in /etc/named.conf.
#
# * `$domains`
#   The domains used to create the zone files, configured in /etc/named.conf and /var/named/{{ zone file }}.
#
# * `$nodes`
#   The hosts and IPs to define in the zone files, configured in /var/named/{{ zone file }}.
#
# * `$puppet_ip`
#   The IP address of the puppet server to define in the zone file, configured in /var/named/{{ zone file }}.
#
# Examples
# --------
#
# @example
#    node default {
#      include linux
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
class named (
  $forwarders,
  $server_ip,
  $domains,
  $nodes,
  $puppet_ip,
  ) {

  package { 'bind':
    ensure => installed,
  }

  service { 'named':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['bind'],
  }

  file { '/etc/named.conf':
    content => template('named/named.conf.erb'),
    notify  => Service['named'],
  }

  $domains.each |$domain| {
    file { "/var/named/${domain['name']}.zone":
      content => template('named/domain.zone.erb'),
      notify  => Service['named'],
    }
  }
}
