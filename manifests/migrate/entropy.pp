# @summary Migrates an entropy system to luet
#
# This class runs the `luet migrate-entropy` command once to reflect
# that the contents of the entropy package database are installed
# within the luet package database.
#
# This class should be included in the catalog for systems you
# want to be migrated to luet.
#
#
class luet::migrate::entropy {

  include luet

  $lock_file = '/var/luet/db/.migrated.entropy'

  exec {
    'luet-migrate-entropy':
      command => "/usr/bin/luet migrate-entropy && touch ${lock_file}",
      creates => $lock_file,
      require => Class['luet::install'];
  }

  # Ensure entropy is installed and migrated before luet is marked as ready
  Class['luet::install']
  -> Class['luet::migrate::entropy']
  -> Class['luet::ready']

}
