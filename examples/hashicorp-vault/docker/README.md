## Vault users and roles creation example in Docker

That directory contains docker-compose example that represents the process of creating a user in  Hashicorp Vault.

To bring up local docker Hashicorp Vault instance
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
[http://localhost:8300](http://localhost:8300)
and authenticating with `lev/training`.
or by directly with vault cli.
See run.sh for more information.

