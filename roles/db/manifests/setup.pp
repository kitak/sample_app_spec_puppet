class db::setup {
  $mysql_root_password = "L0BrEpuva"
  $mysql_app_password = "AV8jsDIml"
  $host = "192.168.%.%"

  exec { "set mysql root password":
    path    => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password ${mysql_root_password}",
    unless  => "mysqladmin -uroot -p${mysql_root_password} status",
  }

  exec { "create mysql user for app":
    path    => ["/bin", "/usr/bin"],
    command => "mysql -uroot -p${mysql_root_password} -e \"GRANT ALL PRIVILEGES ON sample_app_production.* TO app@'${host}' identified by '${mysql_app_password}'; FLUSH PRIVILEGES;\"",
    unless  => "mysqladmin -uapp -p${mysql_app_password} status",
    require => Exec['set mysql root password'],
  }

  exec { "create production database":
    path    => ["/bin", "/usr/bin"],
    command => "mysql -uroot -p${mysql_root_password} -e \"CREATE DATABASE sample_app_production DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;\"",
    onlyif  => "test `mysql -uroot -p${mysql_root_password} -e \"SHOW DATABASES LIKE 'sample_app_production'\\G\" | wc -l` -eq 0",
    require => Exec['create mysql user for app'],
  }
}
