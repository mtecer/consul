# Secret environment variables are sourced from  ~/.terraform_openstack_sandbox_rc
# source  ~/.terraform_openstack_sandbox_rc
variable "openstack_vm_api_ip" {}
variable "openstack_vm_domain_name" {}
variable "openstack_vm_no_proxy" {}
variable "openstack_vm_proxy" {}

variable "ansible_user" {}
variable "ansible_home" {}

variable "consul_version" {}
variable "consul_ansible_repo" {}

variable "auth_url" {}
variable "domain_name" {}
variable "tenant_name" {}
variable "user_name" {}
variable "password" {}

variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "consul_count" {}
variable "consul_image" {}
variable "consul_flavor" {}
variable "consul_keypair" {}
variable "consul_network" {}
variable "consul_volume_size" {}
variable "consul_securitygroups" {}