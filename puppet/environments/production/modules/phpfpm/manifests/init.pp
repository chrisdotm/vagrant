class phpfpm {
  file {'/etc/php-fpm.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    purge  => true,
  }
}
