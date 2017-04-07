define phpfpm::instance (
  $listen,
  $user,
  $group,
  $listen_type  = 'sock',
  $listen_owner = $user,
  $listen_group = $group,
  $listen_mode  = '0660',
) {

  service { 'php-fpm':
    ensure => running,
    enable => true,
    subscribe => File["/etc/php-fpm.d/${title}.conf"],
  }

  file { "/etc/php-fpm.d/${name}.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('phpfpm/config.erb'),
  }

}
