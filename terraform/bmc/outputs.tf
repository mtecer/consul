# Output the private and public IPs of the instance

output "Consul Server - consul1 IP" {
  value = "${data.baremetal_core_vnic.consul1-Vnic.public_ip_address}\n"
}

output "Consul Server - consul2 IP" {
  value = "${data.baremetal_core_vnic.consul2-Vnic.public_ip_address}\n"
}

output "Consul Server - consul3 IP" {
  value = "${data.baremetal_core_vnic.consul3-Vnic.public_ip_address}\n"
}

output "Consul Client - consul4 IP" {
  value = "${data.baremetal_core_vnic.consul4-Vnic.public_ip_address}\n"
}

output "Consul Client - consul5 IP" {
  value = "${data.baremetal_core_vnic.consul5-Vnic.public_ip_address}\n"
}

output "Consul Client - consul6 IP" {
  value = "${data.baremetal_core_vnic.consul6-Vnic.public_ip_address}\n"
}

output "Consul cluster INFO" {
  value = ["\n\t** List of Consul cluster Web URLs **\n\t- http://${data.baremetal_core_vnic.consul1-Vnic.public_ip_address}:8500\n\t- http://${data.baremetal_core_vnic.consul2-Vnic.public_ip_address}:8500\n\t- http://${data.baremetal_core_vnic.consul3-Vnic.public_ip_address}:8500\n"]
}


