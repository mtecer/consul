ssh_key_path = "~/Projects/keys/"
vagrant_ssh_private_key = "vagrant-key"
vagrant_ssh_public_key = "vagrant-key.pub"

$nodes = {
  'consul1' => { 'ip' => '172.28.128.11', 'groups' => [ 'consul' ] },
  'consul2' => { 'ip' => '172.28.128.12', 'groups' => [ 'consul' ] },
  'consul3' => { 'ip' => '172.28.128.13', 'groups' => [ 'consul' ] },
}

$groups = {}
$nodes.each do | hostname, details |
  details['groups'].each do |d|
    if ! $groups.has_key?(d)
      $groups[d] = [ "#{hostname}", ]
    else
      $groups[d].push("#{hostname}")
    end
  end
end

File.open('ansible-hosts' ,'w') { |f| f.write("# Ansible inventory generated by Vagrant\n\n") }
$groups.each do | group, members |
  File.open('ansible-hosts', 'a') { |f| f.write("[#{group}]\n") }
  members.each do |m|
    File.open('ansible-hosts', 'a') { |f| f.write("#{m}\n") }
  end
  File.open('ansible-hosts', 'a') { |f| f.write("\n") }
end
File.open('ansible-hosts', 'a') { |f| f.write("[default]\n") }

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install  = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote   = true
  end

  config.ssh.insert_key = false
  config.ssh.password = nil
  config.ssh.private_key_path = [ "#{ ssh_key_path + vagrant_ssh_private_key }", "~/.vagrant.d/insecure_private_key" ]
  config.vm.box_check_update = false

  $nodes.each_with_index do |(hostname, details), index|
    config.vm.define "#{hostname}" do |node|
      node.vm.provider "virtualbox" do |v|
        v.cpus = 1
        v.linked_clone = true
        v.memory = 1024
        v.name = "#{hostname}"
      end # node.vm.provider

      # node.vm.box = "centos/7"
      node.vm.box = "centos-7-ansible"
      node.vm.hostname = "#{hostname}"
      node.vm.network "forwarded_port", guest: 8080, host: "8080", auto_correct: true
      node.vm.network "private_network", ip: "#{details['ip']}"
      node.vm.synced_folder ".", "/vagrant", disabled: true

      File.open('ansible-hosts' , 'a') do |f|
        f.write "#{hostname} ansible_ssh_host=#{details['ip']} ansible_ssh_user=vagrant ansible_ssh_private_key_file=~/.ssh/#{vagrant_ssh_private_key}\n"
      end
      
      node.vm.provision "file", source: "#{ ssh_key_path + vagrant_ssh_public_key }", destination: "~/.ssh/authorized_keys"
      
      if index == $nodes.size - 1
        node.vm.provision "file", source: "#{ ssh_key_path + vagrant_ssh_private_key }", destination: "~/.ssh/#{vagrant_ssh_private_key}"
        node.vm.provision "shell", path: "bootstrap-ansible.sh", args: "consul"
        node.vm.provision "file", source: "ansible-hosts", destination: "/ansible/environments/dev/hosts"
        $run_ansible = <<-SHELL
          cd /ansible
          sudo su vagrant -c 'ansible-galaxy install -r /ansible/requirements.yaml --roles-path /ansible/roles'
          sudo su vagrant -c 'ansible -m ping all'
        SHELL
        node.vm.provision "shell", inline: $run_ansible
      end # if index ==

    end # node.vm.define
  end # $nodes.each_with_index
end # Vagrant.configure