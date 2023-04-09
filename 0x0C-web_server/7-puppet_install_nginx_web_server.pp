#Install Nginx with Puppet

# Execute apt package update
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

# Install nginx
package { 'nginx':
  ensure  => "installed",
  require => Exec['apt-get update']
}

# Content of index.html
file { '/var/www/html/index.html':
  content => "Hello World!",
  require => Package['nginx']
}

#Configure redirect in config file
file_line { 'default':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  after  => 'listen 80 default_server;',
  line   => 'rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4;'
}

# Create service to restart nginx
service { 'nginx':
  ensure => running,
  require => Package['nginx']
}
