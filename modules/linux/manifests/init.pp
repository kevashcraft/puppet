# Class: linux
# ===========================
#
# Kevin's Puppet Module for maintaining Linux packages, services, and users.
#
# Parameters
# ----------
#
# * `$search_domains`
#   The list of domains to search resolv.conf.
#
# * `$nodes`
#   The list of global nodes, refined to a list of domain names for resolv.conf.
#
# * `$nameserver`
#   The nameserver, defined in domain::&dns_ip and passed to linux::nameserver,
#   is used in resolv.conf.
#
# * `$users`
#   The node-specifc list of users, defined in linux::users,
#   is used to create the users.
#
# * `$groups`
#   The node-specifc list of groups, defined in linux::groups,
#   is used to create the groups.
#
# * `$global_users`
#   The global list of users, defined domain::users and passed to linux::global_users,
#   is used to create the users.
#
# * `$global_groups`
#   The global list of groups, defined domain::groups and passed to linux::global_groups,
#   is used to create the groups.
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
class linux (
  $nodes,
  $search_domains,
  $nameserver,
  $root_pw,
  $users,
  $groups,
  $global_users,
  $global_groups,
  $packages,
  $services,
  $global_packages,
  $global_services,
) {

  file { '/etc/resolvconf.conf':
    content => template('linux/etc/resolvconf.conf.erb'),
  }

  file { '/etc/resolv.conf':
    content => template('linux/etc/resolv.conf.erb'),
  }

  file { '/etc/hostname':
    content => template('linux/etc/hostname.erb'),
  }

  ($global_groups + $groups).each |$group| {
    group { $group:
      ensure   => present,
    }
  }

  user { 'root':
    ensure   => present,
    password => $root_pw,
  }

  ($global_users + $users).each |$user| {
    user { $user['username'] :
      ensure     => present,
      comment    => $user['comment'],
      managehome => true,
      home       => "/home/${user['username']}",
      groups     => $user['groups'],
      password   => $user['password'],
      shell      => '/bin/bash',
    }

    file { "/home/${user['username']}":
      ensure  => directory,
      require => User[$user['username']],
      owner   => 'kevin',
      group   => 'kevin',
    }

    file { "/home/${user['username']}/.ssh":
      ensure  => directory,
      require => File["/home/${user['username']}"],
      owner   => 'kevin',
      group   => 'kevin',
    }

    file { "/home/${user['username']}/.ssh/authorized_keys":
      require => File["/home/${user['username']}/.ssh"],
      owner   => 'kevin',
      group   => 'kevin',
      source  => [
        "puppet:///modules/linux/home/${user['username']}/.ssh/authorized_keys",
        'puppet:///modules/linux/home/default/.ssh/authorized_keys',
      ],
    }
  }

  ($global_packages + $packages).each |$package| {
    if ($package == 'vim') {
      case $::osfamily {
        'redhat': {
          $package_actual = 'vim-enhanced'
        }
        default: {
          $package_actual = 'vim'
        }
      }
    } else {
      $package_actual = $package
    }

    package { $package_actual:
      ensure   => present,
    }
  }

  ($global_services + $services).each |$service| {
    service { $service:
      ensure => running,
      enable => true,
      #hasrestart => true,
      #hasstatus  => true,
    }
  }
}
