# Class: opencsw
#
# Manages OpenCSW and pkgutil on Solaris systems
#
class opencsw (
  $package_source = 'http://get.opencsw.org/now',
  $mirror         = 'http://mirror.opencsw.org/opencsw/stable',
  $pkgaddopts     = '-G',
  $wgetopts       = '-nv',
  $use_gpg        = false,
  $use_md5        = false,
) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  staging::file { 'CSWpkgutil.pkg':
    target => '/var/sadm/pkg/CSWpkgutil.pkg',
    source => $package_source,
    before => Package['CSWpkgutil'],
  }

  file { '/var/sadm/install/admin/opencsw-noask':
    ensure => file,
    source => 'puppet:///modules/opencsw/opencsw-noask',
    before => Package['CSWpkgutil'],
  }

  package { 'CSWpkgutil':
    ensure    => 'latest',
    provider  => sun,
    source    => '/var/sadm/pkg/CSWpkgutil.pkg',
    adminfile => '/var/sadm/install/admin/opencsw-noask',
  }

  # Template uses:
  #   - $mirror
  #   - $pkgaddopts
  #   - $wgetopts
  #   - $use_gpg
  #   - $use_md5
  file { '/etc/opt/csw/pkgutil.conf':
    ensure  => file,
    content => template('opencsw/pkgutil.conf.erb'),
    require => Package['CSWpkgutil'],
  }

  file { '/opt/csw/etc/pkgutil.conf':
    ensure  => symlink,
    target  => '/etc/opt/csw/pkgutil.conf',
    require => Package['CSWpkgutil'],
  }

  # This creates the catalog file, looks like this:
  # - catalog.sunkist6.eb.lan.at_opencsw_testing_i386_5.10
  # - catalog.sunkist6.eb.lan.at_osscsw_i386_5.10
  $mangled = regsubst(regsubst($mirror, '(^.*//)', ''), '/', '_', 'G')
  $catalog = "catalog.${mangled}_${::hardwareisa}_${::kernelrelease}"
  exec { 'pkgutil-update':
    command => '/opt/csw/bin/pkgutil -U',
    creates => "/var/opt/csw/pkgutil/${catalog}",
    require => File['/etc/opt/csw/pkgutil.conf'],
  }

}
