data "openstack_images_image_v2" "consul_image" {
  name = "${var.consul_image}"
  most_recent = true
}
data "openstack_images_image_v2" "consul_client_image" {
  name = "${var.consul_client_image}"
  most_recent = true
}
data "openstack_images_image_v2" "consul_admin_image" {
  name = "${var.consul_admin_image}"
  most_recent = true
}
data "template_file" "bootstap_ansible_sh" {
  template = "${file("${path.module}/templates/bootstrap-ansible.sh.tpl")}"
  vars {
    ssh_private_key     = "${var.ssh_private_key}"
    ansible_user        = "${var.ansible_user}"
    ansible_home        = "${var.ansible_home}"
    consul_ansible_repo = "${var.consul_ansible_repo}"
  }
}
data "template_file" "ansible_external_variables_yaml" {
  template = "${file("${path.module}/templates/external_variables.yaml.tpl")}"
  vars {
    openstack_vm_api_ip       = "${var.openstack_vm_api_ip}"
    openstack_vm_domain_name  = "${var.openstack_vm_domain_name}"
    openstack_vm_no_proxy     = "${var.openstack_vm_no_proxy}"
    openstack_vm_proxy        = "${var.openstack_vm_proxy}"
    consul_version            = "${var.consul_version}"
    consul_template_version   = "${var.consul_template_version}"
  }
}

resource "openstack_compute_servergroup_v2" "consul" {
  name     = "consul"
  policies = ["anti-affinity"]
}
resource "openstack_compute_servergroup_v2" "consul_client" {
  name     = "consul_client"
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "consul" {
  count                   = "${var.consul_count}"
  name                    = "consul0${count.index+1}"
  flavor_name             = "${var.consul_flavor}"
  key_pair                = "${var.consul_keypair}"
  security_groups         = [ "${var.consul_securitygroups}" ]
  block_device {
    uuid                  = "${data.openstack_images_image_v2.consul_image.id}"
    source_type           = "image"
    volume_size           = "${var.consul_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  network {
    name                  = "${var.consul_network}"
  }
  scheduler_hints {
    group                 = "${openstack_compute_servergroup_v2.consul.id}"
  }
}

resource "openstack_compute_instance_v2" "consul_client" {
  count                   = "${var.consul_client_count}"
  name                    = "client0${count.index+1}"
  flavor_name             = "${var.consul_client_flavor}"
  key_pair                = "${var.consul_client_keypair}"
  security_groups         = [ "${var.consul_client_securitygroups}" ]
  block_device {
    uuid                  = "${data.openstack_images_image_v2.consul_client_image.id}"
    source_type           = "image"
    volume_size           = "${var.consul_client_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  network {
    name                  = "${var.consul_client_network}"
  }
  scheduler_hints {
    group                 = "${openstack_compute_servergroup_v2.consul_client.id}"
  }
}

resource "openstack_compute_instance_v2" "consul_admin" {
  depends_on = [
    "openstack_compute_instance_v2.consul",
  ]
  count                   = "1"
  name                    = "consul-admin"
  flavor_name             = "${var.consul_admin_flavor}"
  key_pair                = "${var.consul_admin_keypair}"
  security_groups         = [ "${var.consul_admin_securitygroups}" ]
  user_data               = "${data.template_file.bootstap_ansible_sh.rendered}"
  block_device {
    uuid                  = "${data.openstack_images_image_v2.consul_admin_image.id}"
    source_type           = "image"
    volume_size           = "${var.consul_admin_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  network {
    name                  = "${var.consul_admin_network}"
  }
}

resource "null_resource" "ansible" {
  triggers {
    key = "${uuid()}"
  }
  depends_on = [
    "openstack_compute_instance_v2.consul",
    "openstack_compute_instance_v2.consul_admin",
  ]
  connection {
    type        = "ssh"
    agent       = false
    timeout     = "5m"
    host        = "${openstack_compute_instance_v2.consul_admin.0.access_ip_v4}"
    user        = "root"
    private_key = "${var.ssh_private_key}"
  }
  provisioner "remote-exec" "ansible_hosts"{
    inline = [
      "echo '[consul_server]' > /ansible/environments/dev/hosts",
      "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", openstack_compute_instance_v2.consul.*.name, openstack_compute_instance_v2.consul.*.access_ip_v4))}\" >> /ansible/environments/dev/hosts",
      "echo '\n[consul_client]' >> /ansible/environments/dev/hosts",
      "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", openstack_compute_instance_v2.consul_client.*.name, openstack_compute_instance_v2.consul_client.*.access_ip_v4))}\" >> /ansible/environments/dev/hosts",
      "echo '\n[consul_bootstrap]' >> /ansible/environments/dev/hosts",
      "echo \"${format("%s ansible_ssh_host=%s", openstack_compute_instance_v2.consul.0.name, openstack_compute_instance_v2.consul.0.access_ip_v4)}\" >> /ansible/environments/dev/hosts",
      "echo '\n[consul_admin]' >> /ansible/environments/dev/hosts",
      "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", openstack_compute_instance_v2.consul_admin.*.name, openstack_compute_instance_v2.consul_admin.*.access_ip_v4))}\" >> /ansible/environments/dev/hosts",
      "echo '\n[consul:children]\nconsul_server\nconsul_client\n' >> /ansible/environments/dev/hosts",
      ]
  }
  provisioner "file" "ansible_variables"{
    content     = "${data.template_file.ansible_external_variables_yaml.rendered}"
    destination = "/ansible/external_variables.yaml"
  }
  provisioner "remote-exec" "run_ansible" {
    inline = [
      "cd /ansible && git pull",
      "while true; do if [ -x /usr/bin/ansible-playbook ]; then break; fi done",
      "sleep 10",
      "ansible-playbook playbook.yaml",
    ]
  }
}

output "Consul Servers" {
  value = "\n${join( "\n", formatlist("  %s - %s", openstack_compute_instance_v2.consul.*.name, openstack_compute_instance_v2.consul.*.access_ip_v4) )}\n"
}
output "Consul Clients" {
  value = "\n${join( "\n", formatlist("  %s - %s", openstack_compute_instance_v2.consul_client.*.name, openstack_compute_instance_v2.consul_client.*.access_ip_v4) )}\n"
}
output "Consul Admin Servers" {
  value = "\n${join( "\n", formatlist("  %s - %s", openstack_compute_instance_v2.consul_admin.*.name, openstack_compute_instance_v2.consul_admin.*.access_ip_v4) )}\n"
}