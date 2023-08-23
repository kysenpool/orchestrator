## Vault provisioning with ansible

References:

[Ansible Vagrant guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vagrant.html)

[Unsealed Vault Ansible playbook](https://github.com/AvalancheDev/Hashicorp-Vault-Ansible)

In that example we will:
- create virtual machine with vagrant (OS: ubuntu/bionic64)
- install ansible on that machine 
- install vault 1.13.3 with ansible on that VM
- unseal the vault on the last step

In order to spin up machine
```shell
vagrant up
```

Ssh into machine
```shell
vagrant ssh
```

Cleanup after tests.
```shell
vagrant destroy
```

Find your key for root user in stdout or in `rootKey` directory.
[http://localhost:8200](http://localhost:8200)