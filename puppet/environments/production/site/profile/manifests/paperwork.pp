class profile::paperwork {

  include epel
  include mysql::server
  include nginx
  class { 'remi':
    remi_php70_enabled => 1,
    remi_safe_enabled  => 1,
  }

  phpfpm::instance { 'paperwork':
    listen       => '/var/run/php-fpm/php-fpm.sock',
    user         => 'nginx',
    group        => 'nginx',
    listen_mode  => '0660',
  }

  nginx::resource::server { 'paperwork.lab':
    ensure               => present,
    listen_port          => 80,
    www_root             => '/var/www/html/paperwork/frontend/public',
    use_default_location => false,
    index_files          => ['index.php', 'index.html', 'index.htm'],
    try_files            => ['$uri', '$uri/', '@rewrite'],
    server_name          => ['paperwork.lab', '_']
  }

  nginx::resource::location { '/':
    ensure              => present,
    server              => 'paperwork.lab',
    location            => '/',
    try_files           => ['$uri', '$uri/', '@rewrite'],
    priority            => '401'
  }
  nginx::resource::location { '@rewrite':
    ensure              => present,
    location_custom_cfg => { 'rewrite' => '^/(.*)$ /index.php?_url=/$1' },
    server              => 'paperwork.lab',
    priority            => '402'
  }

  nginx::resource::location { 'php':
    ensure              => present,
    server              => 'paperwork.lab',
    location            => '~ \.php$',
    fastcgi             => 'unix:/var/run/php-fpm/php-fpm.sock',
    location_cfg_append => {
      fastcgi_index           => 'index.php',
      fastcgi_split_path_info => '^(.+\.php)(/.+)$',
      fastcgi_param           => {
        'PATH_INFO'       => '$fastcgi_path_info',
        'PATH_TRANSLATED' => '$document_root$fastcgi_path_info',
        'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name',
      },
    },
    priority            => '403'
  }

  nginx::resource::location { 'resources':
    ensure   => present,
    server   => 'paperwork.lab',
    location => '~* ^/(css|img|js|flv|swf|download)/(.+)$',
    www_root => '/var/www/html/paperwork/frontend/public',
    priority => '404'
  }

  nginx::resource::location { 'ht':
    ensure        => present,
    server        => 'paperwork.lab',
    location      => '~ /\.ht',
    location_deny => ['all'],
    priority      => '405'
  }

  mysql::db { 'paperwork':
    user     => 'paperwork',
    password => 'paperwork',
    dbname   => 'paperwork',
    host     => 'localhost',
    grant    => ['ALL'],
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
  }

  Package {
    require => [
      Class['epel'],
      Class['remi'],
    ]
  }

  package { 'php':
    ensure => latest,
  }

  package { 'curl':
    ensure => latest,
  }

  package { 'git':
    ensure => latest,
  }

  package { 'php-fpm':
    ensure => latest,
  }

  package { 'php-gd':
    ensure => latest,
  }

  package { 'php-mcrypt':
    ensure => latest,
  }

  package { 'php-mysqlnd':
    ensure => latest,
  }

  package { 'php-xml':
    ensure => latest,
  }

  package { 'php-zip':
    ensure => latest,
  }

  package { 'wget':
    ensure => latest,
  }

  package { 'nodejs':
    ensure => latest,
  }

  package { 'gulp':
    ensure   => latest,
    provider => 'npm',
  }

  package { 'bower':
    ensure   => latest,
    provider => 'npm',
  }

  file { '/root/install_paperwork.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/paperwork/setup.sh',
  }
}
