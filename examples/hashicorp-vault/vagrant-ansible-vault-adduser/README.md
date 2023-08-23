## User and roles creation

That directory contains docker-compose example that represents the process of creating a user in  Hashicorp Vault.

Depends on vagrant-ansible-example (it should be provisioned prior).

To apply playbook 
```shell
ansible-playbook -i hosts deploy.yml --extra-vars "vault_root_key=$(cat ../vagrant-ansible-example/rootKey/rootKey)"
```

Test by going to
[http://localhost:8200](http://localhost:8200)
and authenticating with `lev/training`
or by directly with vault cli.
See run.sh for more information.
