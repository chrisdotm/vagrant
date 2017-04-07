class profile::base {

  include epel
  include vim


  #kill the selinux!!
  class { 'selinux':
    mode => 'disabled'
  }

}
