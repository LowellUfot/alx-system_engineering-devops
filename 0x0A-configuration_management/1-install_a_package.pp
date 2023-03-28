# Using Puppet, install flask from pip3

exec {'flask-install':
  command => '/usr/bin/apt-get update'
}

package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3',
  require  => Exec['flask-install']
}
