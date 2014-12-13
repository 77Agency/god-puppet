define god::process ($name,$pidfile,$start_command, $stop_command, $restart_command) {
  file { "god-$name": 
    path => "/etc/god/conf.d/$name.god",
    content => template("god/sample.god.erb"),
    mode => "0644",
    require => Class["god"]
  }
}
