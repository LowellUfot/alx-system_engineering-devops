# define directory for custom page in a variable
$doc_root = "/var/www/html"

# execute apt package update
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

# install nginx
package { 'nginx':
  ensure  => "installed",
  require => Exec['apt-get update']
}

# adjust the firewall
exec { 'firewall':
  command => 'ufw allow "Nginx HTTP"',
  require => Package['nginx']
}

# create directory for doc_root
file { $doc_root:
  ensure => "directory"
}

# custom string
$str = "Hello World!"

# content of index.html
file { "$doc_root/index.html":
  content => $str,
  require => File[$doc_root]
}

# redirect link
$rdr = "https://www.youtube.com/watch?v=QH2-TGUlwu4"

# configure /redirect_me
file { '/etc/nginx/sites-available/default':
  ensure  => file,
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

# create service to restart nginx
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => File['/etc/nginx/sites-available/default']
}
