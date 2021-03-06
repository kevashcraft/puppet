# Class: sshd
# ===========================
#
# Kevin's Puppet Module to configure sshd.
#
# Parameters
# ----------
#
# * `$port`
#   The port number to listen to for SSH connections.
#
# * `$users`
#   The list of users to allow SSH access.
#
# * `$global_users`
#   The global list of users to allow SSH access.
#
# * `$server_ip`
#   The ip address to listen on for sshd connections.
#
# Examples
# --------
#
# @example
#    node default {
#      include sshd
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
class sshd (
  $port,
  $users,
  $global_users,
  $server_ips,
  ) {

  $ssh_users = $global_users + $users

  $osfamily = $::osfamily

  case $::osfamily {
    'archlinux': {
      $openssh = 'openssh'
    }
    default: {
      $openssh = 'openssh-server'
    }
  }

  package { $openssh:
    ensure => installed,
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$openssh],
  }

  file { '/etc/ssh/sshd_config':
    content => template('sshd/sshd_config.erb'),
    notify  => Service['sshd'],
  }
}
