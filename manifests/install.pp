# == Class: luet::install
#
# Installs the luet package manager
#
class luet::install {

  if $luet::manage_install {

    if $luet::install_method == 'repo' {

      package { 'luet':
        ensure => installed
      }

    } elsif $luet::install_method == 'source' {

      exec {
        'install-luet':
          command => 'curl -q https://get.mocaccino.org/luet/get_luet_root.sh | /bin/sh',
          creates => '/usr/bin/luet',
          path    => ['/bin', '/usr/bin', '/usr/local/bin']
      }

    }

    # Ensure luet is installed before any packages are installed using luet explicitly
    # We can't force this for packages where the provider is not set explicitly as its only
    # resolved by the agent at runtime
    Class['luet::install'] -> Package<| provider == luet |>

  }

}
