#!/bin/sh
# This script will install iptables status check settings on a Debian 9 server.

# Download iptables config file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Debian9/Config/iptables.conf -O /etc/zabbix/zabbix_agentd.d/iptables.conf

# Download iptablescheck shell script file for Zabbix agent
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Debian9/Script/iptablescheck.sh -O /usr/local/bin/iptablescheck.sh

# Make iptablescheck shell script file executable
chmod +x /usr/local/bin/iptablescheck.sh

# Restart Zabbix agent
systemctl restart zabbix-agent

# Success message
echo "Iptables status check settings for Zabbix successfully installed!"