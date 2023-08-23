##Vault users and roles creation example in Docker
That directory contains docker-compose example representing User creation process in Hashicorp Vault.
Depending on vagrant-ansible-example (it should be provisioned prior).

To bring up local docker hashicorp vault
```shell
docker compose up -d
```
To stop
```shell
docker compose stop
```
To cleanup
```shell
docker compose down
```

Test by going to
http://127.0.0.1:8300/ui/vault
and authenticating with lev/training.
or by directly with vault cli.
See run.sh for more information.

