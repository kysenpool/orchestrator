# Cosmos-based Node Ansible Setup Plus Several Supporting Playbooks For Ununifi

Based on [polkachu cosmos-validators](https://github.com/polkachu/cosmos-validators/)

## Design Philosophy

1. Support both mainnet and testnet
1. Stable playbooks and roles; Customizable variables
1. Support essential functions (snapshot, state-sync) through separate playbooks

## TL/DR

You run one playbook and set up a node.

```bash
ansible-playbook -i inventory_testnet.ini main.yml  -e "protocol=ununifi" -e "target=uninifi_test"
```

It is not recommended for you to sync from Block 1. Rather, please use option `-e  "state_sync=true"` or start from a [snapshot](https://polkachu.com/tendermint_snapshots).

#### Host Variables

Take a look at the `inventory.sample` file. You will see an example `ununifi` group with 3 different hosts: `ununifi_main`, `ununifi_backup`, and `ununifi_relayer`. Each host will have the following variables:

1. `ansible_host`: Required. The IP address of the server.
1. `type`: Required. It can be `main`, `backup` and `relayer` (also `test` if you are adventurous). Each is opinionated in its configuration settings.
1. `prepare`: Optional. If unset, it is default to true. If `false`, it will skip setups of firewall, go, cosmovisor, node exporter, promtail, etc. The reason for the `false` option is because we run many backup/relayer nodes on the same server with setup done already.

#### Other Variables

Besides the above host variables, you will also specify the following `all` variables in the inventory file:

1. `ansible_user`: The sample file assumes `ubuntu`, but feel free to use other user name. This user need sudo privilege.
1. `ansible_port`: The sample file assumes `22`. But if you are like me, you will have a different ssh port other than `22` to avoid port sniffing.
1. `ansible_ssh_private_key_file`: The sample file assumes `~/.ssh/id_rsa`, but you might have a different key location.
1. `var_file`: It tells the program where to look for the variable file. This is useless for the mainnet, because the var file will automatically be inferred by the network name. However, it is essentially for testnets.
1. `user_dir`: The user's home directory. In the sample inventory file this is a computed variable based on the ansible_user. It assumes that it is not a root user and its home directory is `/home/{{ansible_user}}`.
1. `path`: This is to make sure that the ansible_user can access the `go` executable.
1. `node_exporter`: Default is `true`. Change it to `false` if you do not want to install node_exporter
1. `promtail`: Default is `true`. Change it to `false` if you do not want to install promtail
1. `log_monitor`: Enter your monitor server IP if you install promtail.
1. `node_name`: This is your node name for the config.toml file.
1. `log_name`: This is the server name for the promtail service.
1. `pagerduty_key`: This is the PagerDuty key if you use TenderDuty

#### Ready? Go!

One you understand the setup, please first copy it to your own inventory file so you can customize it to suit your needs:

```bash
cp inventory.sample inventory
```

When you are ready install a node, you run:

```bash
ansible-playbook main.yml -e "target=HOST_NAME"
```

## Playbooks

| Playbook                       | Description                                                                                      |
| ------------------------------ | ------------------------------------------------------------------------------------------------ |
| `main.yml`                     | The main playbook to set up a node                                                               |
| `prepare.yml`                  | Prepare the server with node exporter, promtail, go, cosmovisor, and firewall rules              |
| `support_backup_node.yml`      | Install snapshot, state_sync, resync, genesis and prune script on backup node                    |
| `support_snapshot.yml`         | Install snapshot script and a cron job                                                           |
| `support_state_sync.yml`       | Install state-sync script                                                                        |
| `support_resync.yml`           | Install weekly scheduled state-sync and recovery script                                          |
| `support_genesis.yml`          | Install a script to upload genesis                                                               |
| `support_prune.yml`            | Install a script to prune using cosmprund                                                        |
| `support_seed.yml`             | Install seed node with Tenderseed. You need a node_key.json.j2 file so the node_id is consistent |
| `support_tenderduty.yml`       | Install Tenderduty                                                                               |
| `support_scripts.yml`          | Install scripts to make node operations easier                                                   |
| `support_sync_snapshot.yml`    | Sync node from a snapshot                                                                        |
| `support_remove_node.yml`      | Remove a node and clean up                                                                       |



## Supported Networks

See the `group_vars` folder for the list of mainnet and testnet support
