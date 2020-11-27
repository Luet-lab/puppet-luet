# @summary Anchor class used for delaying resources until luet is ready for use
# 
# This class can be used as a dependency on other resources in the catalog
# which should be delayed until after luet is ready for use.
#
# This class is not complete until luet has been installed (if installation is
# being managed by this class), and all enabled migrations have been completed.
#
# This will prevent, for example, luet packages being installed and
# overwriting the content of packages already installed via the previous
# package manager, before the migration into the luet database has been done.
#
# @note Any package resource which specifies the `luet` provider will automatically
#   depend on the `luet::ready` class. This construct is only needed where a provider
#   is not explicitly set. When the provider is not set, the default provider is
#   resolved by the agent at catalog application time, so it's not possible to know
#   at compilation time which provider is going to be used.
#
# @example Delay installation of a specific package until Luet is ready
#   package { 'htop':
#     ensure   => present,
#     category => 'sys-process',
#     require  => Class['luet::ready']
#   }
#
# @example Configure all packages on a system to use luet when ready
#   # in manifests/site.pp
#   if $operatingsystem == 'MocaccinoOS' {
#     Package {
#       provider => 'luet',
#       require  => Class['luet::ready'],
#     }
#   }
#
class luet::ready {

    # We can't force this for packages where the provider is not set explicitly
    # as its only resolved by the agent at runtime
    Class['luet::ready'] -> Package<| provider == luet |>

}
