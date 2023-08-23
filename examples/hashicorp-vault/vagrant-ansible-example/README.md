##Vault provisioning with ansible
References:
https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html
https://github.com/AvalancheDev/Hashicorp-Vault-Ansible

In that example we:
-creating virtual machine with vagrant (OS: ubuntu/bionic64)
-installing ansible on that machine 
-installing vault 1.13.3 with ansible that VM
-unseal the vault as last step

```shell
vagrant up
vagrant ssh
vagrant destroy
```

Find your key for root user in stdout or in rootKey directory
