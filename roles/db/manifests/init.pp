class db {
  include ::mysql 
  include db::setup
  include db::mysql::config
  include db::capistrano

     Class[db::mysql::config]
  ~> Class[::mysql::service]
  -> Class[db::setup]
}
