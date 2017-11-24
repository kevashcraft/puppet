node default {
  include linux
}

node 'k4k.ha.kevashcraft.com' {
  include linux
  include dhcpd
  include named
  include firewalld
  include httpd
}

node 'maint.kevashcraft.com' {
  include linux
  include named
  include firewalld
  include sshd
}

node 'www.kevashcraft.com' {
  include linux
  include sshd
  include firewalld
  include httpd
}

node 'dev.kevashcraft.com' {
  include linux
  include sshd
}
