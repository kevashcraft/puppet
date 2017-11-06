node default {
  include linux
}

node 'k4k.ha.kevashcraft.com' {
  include linux
  include dhcpd
  include named
  include firewalld
}

node 'maint.kevashcraft.com' {
  include linux
  include named
  include firewalld
  include sshd
}
