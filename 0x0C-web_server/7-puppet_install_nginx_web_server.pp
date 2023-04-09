# Define directory for custom page in a variable
$doc_root = "/var/www/html"

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
exec { 'firewall':
  command => 'ufw allow "Nginx HTTP"',
  require => Package['nginx']
}

# Create directory for doc_root
file { $doc_root:
  ensure => "directory"
}

# Custom string
$str = "Hello World!"

# Content of index.html
file {"$doc_root/index.html":
  content => $str,
  require => File[$doc_root]
}

# Redirect link
$rdr = "https://www.youtube.com/watch?v=QH2-TGUlwu4"

# Configure /redirect_me
file { '/etc/nginx/sites-available/default':
  ensure => file,
  content => "
    server {
      listen 80;
      root $doc_root;
      index index.html;

      location /redirect_me {
        return 301 $rdr;
      }
    }
  ",
  require => Package['nginx'],
  notify  => Service['nginx']
}

# Create service to restart nginx
service { 'nginx':
  ensure => running,
  enable => true,
  require => File['/etc/nginx/sites-available/default']
}
