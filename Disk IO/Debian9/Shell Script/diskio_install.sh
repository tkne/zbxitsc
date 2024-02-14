#!/bin/sh
# This script will install Disk IO status check settings on a Debian 9 server.

# Download Disk IO config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Debian9/Config/iostat.conf -O /etc/zabbix/zabbix_agentd.d/iostat.conf

# Download Disk IO Python script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Debian9/Script/lld-disks.py -O /usr/local/bin/lld-disks.py

# Make Disk IO Python script file executable
chmod +x /usr/local/bin/lld-disks.py

# Restart Zabbix agent
systemctl restart zabbix-agent

# Success message
echo "Disk IO status settings for Zabbix successfully installed!"