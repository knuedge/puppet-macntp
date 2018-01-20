# == Class: macntp
#
# Activates and configures NTP synchronization.
#
# === Parameters
#
# This class takes a two parameters:
#
# [*enable*]
#   Whether to enable to ntp client or not.
#   Type: Bool
#   Default: undef
#
# [*servers*]
#   A list of NTP servers to use.
#   Type: Array
#   Default: ['time.apple.com']
#
# === Variables
#
# Not applicable
#
# === Examples
#
# This class was designed to be used with Hiera. As such, the best way to pass
# options is to specify them in your Hiera datadir:
#
#  # Example: defaults.yaml
#  ---
#  managedmac::ntp::enable: true
#  managedmac::ntp::servers:
#    - time.apple.com
#    - time1.google.com
#
# Then simply, create a manifest and include the class...
#
#  # Example: my_manifest.pp
#  include macntp
#
# If you just wish to test the functionality of this class, you could also do
# something along these lines:
#
#  class { 'macntp':
#   enable  => true,
#   servers => ['time.apple.com', 'time1.google.com'],
#  }
#
# This has been forked out of the managedmac module
#
# === Original Authors
#
# Brian Warsing <bcw@sfu.ca>
class macntp (

  $enable  = true,
  $servers = ['time.apple.com']

) {

  unless $enable == false {

    validate_bool  ($enable)
    validate_array ($servers)

    # High Siera replaced ntpd with timed - still has the legacy app installed, but renamed
    if defined('$::macosx_productversion_major') {
      if $facts['macosx_productversion_major'] == '10.13' {
        $ntp_service_label = 'org.ntp.ntpd-legacy'
      } else {
        $ntp_service_label = 'org.ntp.ntpd'
      }
    } else {
      $ntp_service_label = 'org.ntp.ntpd'
    }

    $ntp_conf_default  = 'server time.apple.com'
    $ntp_conf_template = inline_template("<%= (@servers.collect {
      |x| ['server', x].join('\s') }).join('\n') %>")

    $content = $enable ? {
      true  => $ntp_conf_template,
      false => $ntp_conf_default,
    }

    $ensure = $enable ? {
      true  => 'running',
      false => 'stopped',
    }

    file { 'ntp_conf':
      ensure  => file,
      owner   => 'root',
      group   => 'wheel',
      mode    => '0644',
      path    => '/private/etc/ntp.conf',
      content => $content,
      before  => Service[$ntp_service_label],
    }

    service { $ntp_service_label:
      ensure  => $ensure,
      enable  => true,
      require => File['ntp_conf'],
    }

  }
}
