

Full Node Setup
Before starting a full node, the unique identifier of the chain-id wll be needed, which will be released as soon as the genesis file is ready.

Join the network
Once the chain-id has been distributed, it is possible to join the network with the CHAIN_ID:

export CHAIN_ID="namada-mainnet" ## (replace with the actual chain-id)
namada client utils join-network --chain-id $CHAIN_ID

Start your node and sync
CMT_LOG_LEVEL=p2p:none,pex:error namada node ledger run

Optional: If you want more logs, you can instead run

NAMADA_LOG=info CMT_LOG_LEVEL=p2p:none,pex:error NAMADA_CMT_STDOUT=true namada node ledger run

And if you want to save your logs to a file, you can instead run:

TIMESTAMP=$(date +%s)
NAMADA_LOG=info CMT_LOG_LEVEL=p2p:none,pex:error NAMADA_CMT_STDOUT=true namada node ledger run &> logs-${TIMESTAMP}.txt
tail -f -n 20 logs-${TIMESTAMP}.txt ## (in another shell)

Running namada as a systemd service
The below script is a community contribution by Encipher88, and currently only works on Ubuntu machines. It has served useful for many validators.

The below assumes you have installed namada from source, with make install. It at least assumes the respective binaries are in /usr/local/bin/.

which namada ## (should return /usr/local/bin/namada)

The below makes a service file for systemd, which will run namada as a service. This is useful for running a node in the background, and also for auto-restarting the node if it crashes.

sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Environment=CMT_LOG_LEVEL=p2p:none,pex:error
Environment=NAMADA_CMT_STDOUT=true
ExecStart=/usr/local/bin/namada node ledger run
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

Enable the service with the below commands:

sudo systemctl daemon-reload
sudo systemctl enable namadad

Now you can manage the node through systemd commands:

Run the node
sudo systemctl start namadad

Stop the node
sudo systemctl stop namadad

Restart the node
sudo systemctl restart namadad

Show node logs
sudo journalctl -u namadad -f -o cat
