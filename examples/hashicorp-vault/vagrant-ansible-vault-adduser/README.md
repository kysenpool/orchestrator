##User and roles creation
That directory contains ansible playbook example representing User creation process in Hashicorp Vault 
Depending on vagrant-ansible-example (it should be provisioned prior).

```shell
ansible-playbook -i hosts deploy.yml --extra-vars "vault_root_key=$(cat ../vagrant-ansible-example/rootKey/rootKey)"
```

Test by going to http://127.0.0.1:8200 and authenticating with lev/training.
or by directly with vault cli.
See run.sh for more information.
