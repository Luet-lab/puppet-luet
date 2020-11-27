# @summary Handles the installation of luet itself
#
# @api private
#
class luet::install {

  $install_script_url = 'https://get.mocaccino.org/luet/get_luet_root.sh'

  if $luet::install_method == 'repo' {

    package { $luet::package_name:
      ensure => $luet::package_ensure,
    }

  } elsif $luet::install_method == 'source' {

    exec {
      'install-luet':
        command => "curl -q ${install_script_url} | sh",
        path    => ['/bin', '/usr/bin', '/usr/local/bin'],
        creates => '/usr/bin/luet',
    }

  }

  # Ensure luet is installed before it is marked as ready for use
  Class['luet::install'] -> Class['luet::ready']

}
