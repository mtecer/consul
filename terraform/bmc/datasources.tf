# Gets a list of Availability Domains
data "baremetal_identity_availability_domains" "ADs" {
	compartment_id = "${var.tenancy_ocid}"
}

# Gets the OCID of the OS image to use
data "baremetal_core_images" "ImageOCID" {
	compartment_id = "${var.compartment_ocid}"
	operating_system = "${var.InstanceOS}"
	operating_system_version = "${var.InstanceOSVersion}"
}

# CONSUL1

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul1-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul1.id}" 
} 

# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul1-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul1-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CONSUL2

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul2-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul2.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul2-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul2-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CONSUL3

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul3-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul3.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul3-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul3-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CONSUL4

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul4-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul4.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul4-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul4-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CONSUL5

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul5-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul5.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul5-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul5-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CONSUL6

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "consul6-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.consul6.id}" 
} 

# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "consul6-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.consul6-Vnics.vnic_attachments[0],"vnic_id")}" 
}

data "template_file" "etc_hosts" {
  template = "${file("${path.module}/templates/etc_hosts.tpl")}"
  vars {
      consul1 = "${data.baremetal_core_vnic.consul1-Vnic.private_ip_address}"
      consul2 = "${data.baremetal_core_vnic.consul2-Vnic.private_ip_address}"
      consul3 = "${data.baremetal_core_vnic.consul3-Vnic.private_ip_address}"
      consul4 = "${data.baremetal_core_vnic.consul4-Vnic.private_ip_address}"
      consul5 = "${data.baremetal_core_vnic.consul5-Vnic.private_ip_address}"
      consul6 = "${data.baremetal_core_vnic.consul6-Vnic.private_ip_address}"
  }
}

data "template_file" "etc_ansible_hosts" {
  template = "${file("${path.module}/templates/etc_ansible_hosts.tpl")}"
  vars {
      consul1 = "${data.baremetal_core_vnic.consul1-Vnic.private_ip_address}"
      consul2 = "${data.baremetal_core_vnic.consul2-Vnic.private_ip_address}"
      consul3 = "${data.baremetal_core_vnic.consul3-Vnic.private_ip_address}"
      consul4 = "${data.baremetal_core_vnic.consul4-Vnic.private_ip_address}"
      consul5 = "${data.baremetal_core_vnic.consul5-Vnic.private_ip_address}"
      consul6 = "${data.baremetal_core_vnic.consul6-Vnic.private_ip_address}"
  }
}

data "template_file" "bootstap_ansible_sh" {
  template = "${file("${path.module}/templates/bootstrap-ansible.sh.tpl")}"
  vars {
      ssh_private_key= "${var.ssh_private_key}"
  }
}
