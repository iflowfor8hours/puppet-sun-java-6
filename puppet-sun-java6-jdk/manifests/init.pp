# Class: puppet-sun-java6-jdk
#
# This module manages puppet-sun-java6-jdk
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class sunjava6 {

  $release = regsubst(generate("/usr/bin/lsb_release", "-s", "-c"), '(\w+)\s', '\1')

  exec { "apt-get-update":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }

  package { "debconf-utils":
    ensure => installed
  }

  exec { "agree-to-jdk-license":
    command => "/bin/echo -e sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true | debconf-set-selections",
    unless => "debconf-get-selections | grep 'sun-java6-jdk.*shared/accepted-sun-dlj-v1-1.*true'",
    path => ["/bin", "/usr/bin"], require => Package["debconf-utils"],
  }

  exec { "agree-to-jre-license":
    command => "/bin/echo -e sun-java6-jre shared/accepted-sun-dlj-v1-1 select true | debconf-set-selections",
    unless => "debconf-get-selections | grep 'sun-java6-jre.*shared/accepted-sun-dlj-v1-1.*true'",
    path => ["/bin", "/usr/bin"], require => Package["debconf-utils"],
  }

  package { "sun-java6-jdk":
    ensure => latest,
    require => [ Exec["agree-to-jdk-license"], Exec["apt-get-update"] ],
  }

  package { "sun-java6-jre":
    ensure => latest,
    require => [ Exec["agree-to-jre-license"], Exec["apt-get-update"] ],
  }

}
