define god::process ($name,$pidfile = undef,$start_command, $stop_command = undef, $restart_command = undef) {
  file { "god-$name": 
    path => "/etc/god/conf.d/$name.god",
    content => template("god/sample.god.erb"),
    mode => "0644",
    require => Class["god"]
  }
}
