#!/bin/sh
# This script will install iptables status check settings on a Ubuntu 14.04  server.

# Download iptables config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Ubuntu1404/Config/iptables.conf -O /etc/zabbix/zabbix_agentd.d/iptables.conf

# Download iptablescheck shell script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Ubuntu1404/Script/iptablescheck.sh -O /usr/local/bin/iptablescheck.sh

# Make iptablescheck shell script file executable
chmod +x /usr/local/bin/iptablescheck.sh

# Restart Zabbix agent
service zabbix-agent status

# Success message
echo "Iptables status check settings for Zabbix successfully installed!"