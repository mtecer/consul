[consul]
consul1
consul2
consul3
consul4
consul5
consul6

[consul_server]
consul1
consul2
consul3

[consul_agent]
consul4
consul5
consul6

[default]
consul1 ansible_host=${consul1} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=true
consul2 ansible_host=${consul2} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=true
consul3 ansible_host=${consul3} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=true consul_bootstrap=true
consul4 ansible_host=${consul4} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=false
consul5 ansible_host=${consul5} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=false
consul6 ansible_host=${consul6} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key" ansible_nic=ens3 consul_server=false
