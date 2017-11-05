# Kevin's Puppet Modules
Modules and hieradata for
Kevin's Puppet Manifest and Modules

# linux

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started](#setup)
1. [Development - Guide for contributing](#development)
1. [License - Copyright and license](#license)

## Description

Standard server configurations setup with Puppet. These modules handle basic Linux users, packages and files, and additional services such as DHCP and DNS.

## Setup

The main configuration entry points are `manifests/site.pp` and `hieradata/common.yaml` which contain a list of nodes and the global parameters. Additional configuration files are located in `hieradata/nodes/`.

Each of the modules, linux, dhcpd, named, are single-class modules with entry poins at `manifests/init.pp`.

## Development

PRs are welcome! Please create an Issue first as a reference point for discussion of the enhancement.

## License

Copyright 2017 Kevin Ashcraft under the MIT License.
