# luet

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with luet](#setup)
    * [What luet affects](#what-luet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with luet](#beginning-with-luet)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module provides providers for managing repositories and packages
on systems using the luet package manager.

## Setup

### Beginning with luet

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

### Installing luet

If luet is not already installed this module can install it for you. This is
not enabled by default and must be explicitly requested. If luet is packaged
for your operating system, you can install it by setting the `install_method` to
 `repo`. If luet is not packaged, it can still be installed using the install
script from the mocaccino website using `install_method` set to `source`.

```puppet
# Install from a repository using your OS default package manager
class { 'luet':
  manage_install => true,
  install_method => 'repo',
}

# Install from mocaccino website
class { 'luet':
  manage_install => true,
  install_method => 'source',
}
```

Where you are managing the installation of luet yourself, or it comes pre-installed
for example on a MocaccinoOS system, you can use luet simply with the following.

```puppet
include luet
```

### Enabling luet repositories

```puppet
package { 'mocaccino-portage-stable':
  ensure   => present,
  category => 'repository',
  name     => 'mocaccino-portage-stable';
}
```

### Installing packages using luet

This module will suggest luet as the default package manager where luet is the
primary package manager, e.g. on `MocaccinoOS`.

You can explicitly set the luet provider to be used when installing a package.

```puppet
package { 'foo':
  ensure   => installed,
  provider => 'luet',
  # As an example, this package might require the above repository to be installed first
  require  => Package['mocaccino-portage-stable'];
}
```

## Development

This module is under under development and functionality at present is quite
limited. Pull requests to extend or enhance the module are welcome.


