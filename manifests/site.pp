node default {
  include linux
}

node 'k4k.ha.kevashcraft.com' {
  include linux
  include dhcpd
  include named
}
