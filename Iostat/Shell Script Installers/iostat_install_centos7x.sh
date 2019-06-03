#!/bin/sh
# This script will install iostat settings on a Cent OS 7.X server.

# Create folders
mkdir -p /usr/local/zabbix-agent-ops/var/

# Download iostat config files for Zabbix Agent service & Cron service 
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Config/iostat-cron.conf -O /etc/cron.d/iostat-cron.conf
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Config/iostat-params.conf -O /etc/zabbix/zabbix_agentd.d/iostat-params.conf

# Download iostat shell script files for Zabbix Agent service
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Script/dev-discovery.sh -O /usr/local/bin/dev-discovery.sh
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Script/iostat-check.sh -O /usr/local/bin/iostat-check.sh
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Script/iostat-cron.sh -O /usr/local/bin/iostat-cron.sh

# Make shell script files executable
chmod +x /usr/local/bin/dev-discovery.sh
chmod +x /usr/local/bin/iostat-check.sh
chmod +x /usr/local/bin/iostat-cron.sh

# Restart Cron service
systemctl status crond

# Restart Zabbix Agent service
systemctl restart zabbix-agent

# Success message
echo "iostat Settings for Zabbix successfully installed!"