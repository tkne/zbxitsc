#!/bin/sh
# This script will install Disk IO status check settings on a Cent OS 6.X server.

# Download Disk IO config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Config/iostat.conf -O /etc/zabbix/zabbix_agentd.d/iostat.conf

# Download Disk IO shell script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Script/lld-disks.py -O /usr/local/bin/lld-disks.py

# Make Disk IO shell script file executable
chmod +x /usr/local/bin/lld-disks.py

# Restart Zabbix agent
service zabbix-agent restart

# Success message
echo "Disk IO Status Settings for Zabbix successfully installed!"