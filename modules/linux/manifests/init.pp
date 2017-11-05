# Class: linux
# ===========================
#
# Kevin's Puppet Module for maintaining Linux packages, services, and users.
#
# Parameters
# ----------
#
# * `$domain_name`
#   The name of the domain, defined in domain::name and passed to linux::domain_name,
#   is used in resolv.conf.
#
# * `$nameserver`
#   The nameserver, defined in domain::&id_dns_server_ip and passed to linux::nameserver,
#   is used in resolv.conf.
#
# * `$users`
#   The node-specifc list of users, defined in linux::users,
#   is used to create the users.
#
# * `$users_global`
#   The global list of users, defined domain::users and passed to linux::users_global,
#   is used to create the users.
#
# * `$groups`
#   The node-specifc list of groups, defined in linux::groups,
#   is used to create the groups.
#
# * `$groups_global`
#   The global list of groups, defined domain::groups and passed to linux::groups_global,
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
  $domain_name,
  $nameserver,
  $users,
  $users_global,
  $groups,
  $groups_global,
) {

  file { '/etc/resolvconf.conf':
    content => template('linux/etc/resolvconf.conf.erb'),
  }

  file { '/etc/resolv.conf':
    content => template('linux/etc/resolv.conf.erb'),
  }

  ($groups_global + $groups).each |$group| {
    group { $group:
      ensure   => present,
    }
  }

  ($users_global + $users).each |$user| {
    user { $user['username'] :
      ensure   => present,
      comment  => $user['comment'],
      home     => "/home/${user['username']}",
      password => $user['password'],
      shell    => '/bin/bash',
    }

    file { "/home/${user['username']}/.ssh":
      ensure  => directory,
      require => User[$user['username']],
    }

    file { "/home/${user['username']}/.ssh/authorized_keys":
      ensure => directory,
      source => [
        "puppet:///modules/linux/home/${user['username']}/.ssh/authorized_keys",
        'puppet:///modules/linux/home/default/.ssh/authorized_keys',
      ],
    }
  }
}
