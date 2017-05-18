ssh_key_path = "~/Projects/keys/"
vagrant_ssh_private_key = "vagrant-key"
vagrant_ssh_public_key = "vagrant-key.pub"

nodes = {
  'consul1' => { 'ip' => '172.28.128.11' },
  # 'consul2' => { 'ip' => '172.28.128.12' },
  # 'consul3' => { 'ip' => '172.28.128.13' },
}

File.open('ansible-hosts' ,'w') do |f|
  f.write "[default]\n"
end

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
  config.vm.provision "file", source: "#{ ssh_key_path + vagrant_ssh_private_key }", destination: "~/.ssh/#{vagrant_ssh_private_key}"
  config.vm.provision "file", source: "#{ ssh_key_path + vagrant_ssh_public_key }", destination: "~/.ssh/authorized_keys"

  config.vm.provision "shell", path: "bootstrap-controller.sh"

  nodes.each do |hostname, details|
    config.vm.define "#{hostname}" do |node|
      # node.vm.box = "centos/7"
      node.vm.box = "centos-7-ansible"
      node.vm.hostname = "#{hostname}"
      node.vm.network "forwarded_port", guest: 8080, host: "8080", auto_correct: true
      node.vm.network "private_network", ip: "#{details['ip']}"

      # config.vm.synced_folder "./simpleapp", "/usr/local/python/simpleapp", type: "rsync", rsync__exclude: ".git/"
      config.vm.synced_folder ".", "/vagrant", disabled: true

      File.open('ansible-hosts' , 'a') do |f|
        f.write "#{hostname} ansible_ssh_host=#{details['ip']} ansible_ssh_user=vagrant ansible_ssh_private_key_file=~/.ssh/#{vagrant_ssh_private_key}\n"
      end
      
      node.vm.provider "virtualbox" do |v|
        v.cpus = 1
        v.linked_clone = true
        v.memory = 1024
        v.name = "#{hostname}"
      end # node.vm.provider
      # node.vm.provision "shell", path: "bootstrap-consul#{i}.sh"
    end # config.vm.define
  end # nodes.each

  config.vm.provision "file", source: "ansible-hosts", destination: "/ansible/environments/dev/hosts"

end # Vagrant.configure
