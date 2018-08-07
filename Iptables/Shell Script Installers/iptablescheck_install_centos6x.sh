#!/bin/sh
# This script will install iptables status check settings on a Cent OS 6.X server.

# Download iptables config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Configs/iptables.conf -O /etc/zabbix/zabbix_agentd.d/iptables.conf

# Download iptablescheck shell script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Scripts/iptablescheck.sh -O /usr/local/bin/iptablescheck.sh

# Make iptablescheck shell script file executable
chmod +x /usr/local/bin/iptablescheck.sh

# Restart Zabbix agent
service zabbix-agent restart

# Success message
echo "Iptables Status Settings for Zabbix successfully installed!"