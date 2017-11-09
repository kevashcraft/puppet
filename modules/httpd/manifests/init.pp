# Class: httpd
# ===========================
#
# Kevin's Puppet Module to configure an httpd server and virtual hosts.
#
# Parameters
# ----------
#
# * `$search_domains`
#   The list of domains to search resolv.conf.
#
# Examples
# --------
#
# @example
#    node default {
#      include httpd
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
class httpd (
  $sites,
  $admin_email,
  $maint_user,
  $docroot,
  ) {

  $bind_ip = $::puppet_bind_ip

  if $bind_ip {
    $server_ip = $bind_ip
  } else {
    $server_ip = $::puppet_public_ip
  }

  case $::osfamily {
    'Archlinux': {
      $httpd = 'apache'
      $httpd_user = 'http'
      $letsencrypt = 'certbot'
    }
    'redhat': {
      $httpd = 'httpd'
      $httpd_user = 'apache'
      $letsencrypt = 'certbot'

      package { 'mod_ssl':
        ensure  => installed,
        require => Package[$httpd],
      }
    }
    default: {
      $httpd = 'httpd'
      $httpd_user = 'apache'
      $letsencrypt = 'letsencrypt'
    }
  }

  package { $httpd:
    ensure => installed,
  }

  package { $letsencrypt:
    ensure  => installed,
    require => Package[$httpd],
  }

  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$httpd],
  }

  file { '/etc/httpd/conf/httpd.conf':
    content => template('httpd/httpd.conf.erb'),
    notify  => Service['httpd'],
  }

  file { '/etc/httpd/conf.d':
    ensure => directory,
  }

  file { $docroot:
    ensure  => directory,
    owner   => $maint_user,
    group   => $httpd_user,
    selrole => 'object_r',
    seluser => 'system_u',
    seltype => 'httpd_sys_content_t',
  }

  $sites.each |$index, $site| {
    file { "/etc/httpd/conf.d/${index}-${site['domain']}.conf":
      content => template('httpd/virtual_host.conf.erb'),
      notify  => Service['httpd'],
      require => File['/etc/httpd/conf.d'],
    }
  }

}
