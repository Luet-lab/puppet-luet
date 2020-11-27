# @summary Manages the luet package manager
#
# @example Install from existing systems package manager
#   class { 'luet':
#     manage_install => true,
#     install_method => 'repo',
#   }
#
# @example Install from MocaccinoOS website
#   class { 'luet':
#     manage_install => true,
#     install_method => 'source',
#   }
#
# @example Use with pre-installed luet
#   include luet
#
# @example Migrate system from Entropy to Luet
#   # Via luet class
#   class { 'luet':
#     migrate_from => ['entropy']
#   }
#
#   # Or by explicitly including the entropy migration class
#   include luet::migrate::entropy
#
# @param manage_install
#   Defines whether this module should attempt to install the luet package manager
# @param install_method
#   Defines how luet should be installed
# @param package_name
#   Name of the luet package when installed using `repo` method
# @param package_ensure
#   Ensure for the luet package when installed using the `repo` method
# @param migrate_from
#   A lit of package managers which luet should migrate from
#
class luet (
    Boolean $manage_install = false,
    Luet::InstallMethod $install_method = 'repo',
    String $package_name = 'luet',
    String $package_ensure = 'installed',
    Array[Luet::MigrateBackend] $migrate_from = []
) {

  if $manage_install {
    include luet::install
  }

  $migrate_from.each |$backend| {
    include "luet::migrate::${backend}"
  }

  include luet::ready

}
