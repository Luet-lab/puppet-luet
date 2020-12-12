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

### What luet affects

This module can manage installation of the luet package manager on both
systems where luet is made available via native packages, or any other
system via manual installation.

It can be used to install/remove packages using the luet package manager, and
luet repositories (which are themselves managed via packages).

### Setup requirements

Install this module using your `Puppetfile` or `puppet module tool`.

This module has very modest dependencies which will very likely be
preinstalled on your system anyway.

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

### Migrating from another supported package manager

Luet has support from migrating the list of installed packages from other
package managers to aid in migration. At the moment, the only supported 
system by both luet and this module is Sabayon's Entropy package manager.

You can migrate from entropy to luet using one of the following methods.

When installing luet, specify the `migrate_from` parameter:

```puppet
class { 'luet':
    manage_install => true,
    migrate_from   => ['entropy'],
}
```

Alternatively you can include the relevant migration class directly. This
method might be more suitable if you're using an ENC, or including classes
from hiera.

```puppet
include luet::migrate::entropy
```

This module will ensure that migration is done before any packages are
installed when the `luet` provider is specified explicitly. If you are not
specifying a provider and rely on the OS autodetection to select the luet
provider, you might want to make package installations depend on 
`Class['luet::ready']` to prevent packages being installed before the
migration is run.

### Enabling luet repositories

For official luet repositories which are listed in the default
repository index shipped with luet, you can install these using the
puppet `package` resource. These packages use the `repository` category,
so you can install them like this:

```puppet
package { 'mocaccino-portage-stable':
  ensure   => present,
  category => 'repository',
  provider => 'luet',
  name     => 'mocaccino-portage-stable';
}
```

### Installing packages using luet

```puppet
package { 'foo':
  ensure   => installed,
  provider => 'luet',
  # As an example, this package might require the above repository to be installed first
  require  => Package['mocaccino-portage-stable'];
}
```

This module will suggest luet as the default package manager where luet is the
primary package manager, e.g. on `MocaccinoOS`.

You can explicitly set the luet provider to be used when installing a package,
as shown above.

## Development

Both this module and luet itself are under under development and functionality
may be limited. Pull requests to extend or enhance the module are welcome.
