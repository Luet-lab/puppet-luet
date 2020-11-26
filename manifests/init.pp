# == Class: luet
#
# Manages the luet package manager
#
class luet (
    Boolean $manage_install = false,
    Enum['repo', 'source'] $install_method = 'repo',
) {

  include luet::install

}
