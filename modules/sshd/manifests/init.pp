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
  ) {

  $ssh_users = $global_users + $users

  $server_ip = $::puppet_public_ip

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
