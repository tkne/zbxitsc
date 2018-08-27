#!/bin/sh
# This script will install iptables status check settings on a Debian 8.X server.

# Download iptables config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Configs/iptables.conf -O /etc/zabbix/zabbix_agentd.conf.d/iptables.conf

# Download iptablescheck shell script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Script/iptablescheck.sh -O /usr/local/bin/iptablescheck.sh

# Make iptablescheck shell script file executable
chmod +x /usr/local/bin/iptablescheck.sh

# Restart Zabbix agent
service zabbix-agent restart

# Success message
echo "Iptables Status Settings for Zabbix successfully installed!"