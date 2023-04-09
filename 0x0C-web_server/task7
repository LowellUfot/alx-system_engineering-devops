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

# Adjust the firewall
#exec { 'firewall':
#  command => 'ufw allow "Nginx HTTP"',
#  require => Package['nginx']
#}

# Custom string
$str = "Hello World!"

# Content of index.html
#file {"$doc_root/index.html":
file { '/var/www/html/index.html':
  content => $str,
  require => Package['nginx']
}

# Redirect link
$rdr = "https://www.youtube.com/watch?v=QH2-TGUlwu4;"

#Configure redirect in config file
file_line { 'default':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  after  => 'listen 80 default_server;',
  line   => 'rewrite ^/redirect_me $rdr'
}

# Create service to restart nginx
service { 'nginx':
  ensure => running,
  require => Package['nginx']
#  enable => true,
#  require => File['/etc/nginx/sites-available/default']
}
