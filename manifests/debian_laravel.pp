###########################
# laravel Puppet Config   #
###########################
# OS          : Linux     #
# Database    : MySQL 5   #
# Web Server  : Apache 2  #
# PHP version : 5.3       #
###########################

include apache
include php
include mysql

$docroot = '/vagrant/www/laravel/'

# Apache setup
class {'apache::mod::php': }

apache::vhost { 'local.laravel':
	priority => '20',
	port => '80',
	docroot => $docroot,
	configure_firewall => false,
}

a2mod { 'rewrite': ensure => present; }

# PHP Extensions
php::module { ['xdebug', 'mysql', 'curl', 'gd'] : 
    notify => [ Service['httpd'], ],
}
php::conf { [ 'pdo', 'pdo_mysql']:
    require => Package['php5-mysql'],
    notify  => Service['httpd'],
}

# MySQL Server
class { 'mysql::server':
  config_hash => { 'root_password' => 'l1k3ab0ss' }
}

mysql::db { 'laravel':
    user     => 'laravel',
    password => 'password',
    host     => 'localhost',
    grant    => ['all'],
    charset => 'utf8',
}

# Other Packages
$extras = ['vim', 'curl', 'phpunit']
package { $extras : ensure => 'installed' }
