require 'puppet/provider/package'
require 'fileutils'
require 'json'

Puppet::Type.type(:package).provide(:luet, parent: Puppet::Provider::Package) do
  desc 'Provides packaging support for the luet package manager'

  has_feature :versionable
  has_feature :installable
  has_feature :uninstallable
  has_feature :upgradeable

  has_command(:luet, 'luet')

  defaultfor operatingsystem: :MocaccinoOS

  def self.instances
    search_output = luet('search', '--installed', '.', '--output', 'json')
    result = JSON.parse(search_output)

    packages = []
    result['packages'].each do |search_result|
      package = {
        name:     search_result['name'],
        category: search_result['category'],
        ensure:   search_result['version'],
      }
      package[:provider] = :luet

      packages << new(package)
    end

    return packages
  rescue Puppet::ExecutionFailure => detail
    raise Puppet::Error, detail.message
  end

  def install
    should = @resource.should(:ensure)
    name = package_name

    unless [:present, :latest].include?(should)
      name = "#{name}-#{should}"
    end

    begin
      luet('install', '-y', name)
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::Error, detail.message
    end
  end

  # The common package name format.
  def package_name
    raise Puppet::Error, 'luet requires packages have a category set' unless @resource[:category]

    "#{@resource[:category]}/#{@resource[:name]}"
  end

  def uninstall
    luet 'uninstall', '-y', package_name
  rescue Puppet::ExecutionFailure => detail
    raise Puppet::Error, detail.message
  end

  def update
    install
  end

  def query
    package = {
      category: @resource[:category],
      name:     @resource[:name],
    }

    begin
      # Look for latest available version in repositories
      search_available = luet('search', '--output', 'json', "^#{package_name}-[0-9].*$")
      all_available = JSON.parse(search_available)
      if all_available['packages']
        package[:version_available] = all_available['packages'][0]['version']
      end
    rescue Puppet::ExecutionFailure
      package[:version_available] = :absent
    end

    begin
      search_installed = luet('search', '--output', 'json', '--installed', "^#{package_name}-[0-9].*$")
      all_installed = JSON.parse(search_installed)
      package[:ensure] = if all_installed['packages']
                           all_installed['packages'][0]['version']
                         else
                           :absent
                         end
    rescue Puppet::ExecutionFailure
      package[:version_available] = :absent
    end

    # If the package is not available in the repos, assume the installed version is the latest available
    if package[:version] != :absent && package[:version_available] == :absent
      package[:version_available] = package[:ensure]
    end

    package
  end

  def latest
    query[:version_available]
  end
end
