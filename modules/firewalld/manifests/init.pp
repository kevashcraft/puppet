# Class: linux
# ===========================
#
# Kevin's Puppet Module to configure firewalld.
#
# Parameters
# ----------
#
# * `$services`
#   The list of services to be allowed.
#
# * `$posts`
#   The list of ports to be allowed.
#
# * `$rules`
#   The list of rich text rules to be enabled.
#
# * `$global_services`
#   The global list of services to be allowed.
#
# * `$global_posts`
#   The global list of ports to be allowed.
#
# * `$global_rules`
#   The global list of rich text rules to be enabled.
#
# Examples
# --------
#
# @example
#    node default {
#      include firewalld
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
class firewalld (
  $services,
  $ports,
  $rules,
  $global_services,
  $global_ports,
  $global_rules,
  ) {

  $fw_services = $global_services + $services
  $fw_ports = $global_ports + $ports
  $fw_rules = $global_rules + $rules

  package { 'firewalld':
    ensure => installed,
  }

  service { 'firewalld':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['firewalld'],
  }

  file { '/etc/firewalld/zones/public.xml':
    content => template('firewalld/zones/public.xml.erb'),
    notify  => Service['firewalld'],
  }
}
