#!/bin/bash
yum install -y gcc python-devel
pip install salt=2019.2.2
mkdir -p /etc/salt/minion.d
cat <<EOM >/etc/salt/minion
root-dir: /
log_dir: /var/log/salt
startup_states: highstate
log_level: info
retry_dns: 0
master_alive_interval: 10
master_tries: -1
mine_enabled: False
#autosign_grains:
# - os
EOM

cat <<EOM >/etc/systemd/system/salt-minion.service
[Unit]
Description=Salt Minion
#Documentation=man:salt-minion(1) ...
After=network.target

[Service]
KillMode=process
Type=Notify
NotifyAccess=all
LimitNoFile=8192
ExecStart=/usr/bin/salt-minion

[Install]
WantedBy=multi-user.target
EOM

cat <<EOM >/etc/salt/minion.d/masters.conf
master: ["10.10.10.5"]
EOM
