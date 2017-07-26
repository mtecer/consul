openstack_vm_api_ip       = "10.199.51.10"
openstack_vm_domain_name  = "vm.sc9b.os.internal"
openstack_vm_proxy        = "http://10.199.51.5:3128"
openstack_vm_no_proxy     = "127.0.0.1,localhost,169.254.169.254"

ansible_user              = "root"
ansible_home              = "/root"

consul_version            = "0.9.0"
consul_template_version   = "0.19.0"
consul_ansible_repo       = "https://github.com/mtecer/consul.git"

consul_count              = "3"
consul_image              = "CentOS-ml-7.3.1706"
consul_flavor             = "m1.micro"
consul_keypair            = "admin_os_sc9b"
consul_network            = "net55"
consul_volume_size        = "20"
consul_securitygroups     = "allow-all"

consul_client_count           = "3"
consul_client_image           = "CentOS-ml-7.3.1706"
consul_client_flavor          = "m1.micro"
consul_client_keypair         = "admin_os_sc9b"
consul_client_network         = "net55"
consul_client_volume_size     = "20"
consul_client_securitygroups  = "allow-all"

consul_admin_count          = "1"
consul_admin_image          = "CentOS-ml-7.3.1706"
consul_admin_flavor         = "m1.micro"
consul_admin_keypair        = "admin_os_sc9b"
consul_admin_network        = "net55"
consul_admin_volume_size    = "20"
consul_admin_securitygroups = "allow-all" 
