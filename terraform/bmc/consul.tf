resource "baremetal_core_instance" "consul1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul1"
  hostname_label = "consul1"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.2"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "consul2" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul2"
  hostname_label = "consul2"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.4"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "consul3" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul3"
  hostname_label = "consul3"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.4"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "consul4" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul4"
  hostname_label = "consul4"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.8"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "consul5" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul5"
  hostname_label = "consul5"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.4"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "consul6" {
  depends_on = [
    "baremetal_core_instance.consul1",
    "baremetal_core_instance.consul2",
    "baremetal_core_instance.consul3",
    "baremetal_core_instance.consul4",
    "baremetal_core_instance.consul5",
  ]
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "consul6"
  hostname_label = "consul6"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  # shape = "${var.InstanceShape}"
  shape = "VM.Standard1.8"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.bootstap_ansible_sh.rendered)}"
  }
}

resource "null_resource" "consul" {
  triggers {
   content = "${data.template_file.etc_hosts.rendered}"
  }
  depends_on = [
    "baremetal_core_instance.consul6",
  ]
  connection {
    type        = "ssh"
    agent       = false
    timeout     = "5m"
    host        = "${data.baremetal_core_vnic.consul6-Vnic.public_ip_address}"
    user        = "root"
    private_key = "${var.ssh_private_key}"
  }

  provisioner "file" "setup_etc_hosts" {
    content     = "${data.template_file.etc_hosts.rendered}"
    destination = "/etc/hosts"
  }

  # provisioner "remote-exec" "wait_for_provisioning" { inline = [ "sleep 10" ] }

  provisioner "file" "setup_etc_ansible_hosts" {
    content     = "${data.template_file.etc_ansible_hosts.rendered}"
    destination = "/home/opc/hosts"
  }

  # provisioner "remote-exec" "run_ansible" {
  #   inline = [
  #     "cd /ansible",
  #     "ansible-galaxy install -r /ansible/requirements.yaml --roles-path /ansible/roles",
  #     "ansible -m ping all",
  #   ]
  # }
}
