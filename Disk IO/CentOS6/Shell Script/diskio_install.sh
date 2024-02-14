#!/bin/sh
# This script will install Disk IO status check settings on a CentOS 6 server.

# Download Disk IO config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/CentOS6/Config/iostat.conf -O /etc/zabbix/zabbix_agentd.d/iostat.conf

# Download Disk IO Python script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/CentOS6/Script/lld-disks.py -O /usr/local/bin/lld-disks.py

# Make Disk IO Python script file executable
chmod +x /usr/local/bin/lld-disks.py

# Restart Zabbix agent
service zabbix-agent restart

# Success message
echo "Disk IO status settings for Zabbix successfully installed!"