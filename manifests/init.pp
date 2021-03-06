# == Class: god
#
# Full description of class god here.
#
# === Parameters
#
# Document parameters here.
#
# [*ruby*]
#   Version of ruby to be used for rvm
# [*gemset*]
#   Gemset where to install god
#
# === Examples
#
#  class { god:
#    ruby => "ruby-2.0",
#    gemset => "god-gemset"
#  }
#
# === Authors
#
# Author Name a.piana@77agency.com
#

class god ($state = 'present', $ruby = 'ruby-2.0.0-p451', $version = 'latest', $gemset = 'god-gemset' ) {

  if !defined(Class['rvm']) {
   include rvm
  } 

  file { "god-dir":
      path => "/etc/god",
      ensure => "directory"
  }
  file { "god-conf-dir":
      path => "/etc/god/conf.d",
      ensure => "directory"
  }

  $ruby_path = "/usr/local/rvm"
  $ruby_version = "$ruby@$gemset"

  file {"god-config": 
    path => "/etc/god/god.conf",
    require => File["god-dir"],
    content => "God.load \"/etc/god/conf.d/*.god\"\n"
  }

  file {"god-init-script": 
    path => "/etc/init.d/god",
    mode => "0755",
    content => template("god/god.init.erb")
  }

  if (!defined(Rvm_system_ruby[$ruby])) {
    rvm_system_ruby {
      $ruby:
        ensure      => $state,
        default_use => false,
        require => Class['rvm']
    }
  }

  rvm_gemset {
    "$ruby_version":
      ensure  => $state,
      require => Rvm_system_ruby[$ruby];
  }
  rvm_gem {
    "$ruby_version/god":
      ensure  => $version,
      require => Rvm_gemset["$ruby_version"];
  }
  rvm_wrapper {
    'god':
      target_ruby => $ruby,
      prefix      => 'bootup',
      ensure      => $state,
      require => Rvm_gemset["$ruby_version"];
  }
  service {"god":
    name => "god",
    ensure => "running",
    enable => true,
    hasrestart => true
  }
}
