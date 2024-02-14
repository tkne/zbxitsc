iptables status check for Zabbix agent on Rocky Linux 9 (Blue Onyx)
======

This guide assumes that the Zabbix agent user config path is set to `/etc/zabbix/zabbix_agentd.d/` or `/etc/zabbix/zabbix_agentd.d/*.conf`, and that the iptables service is utilized as the system's firewall. If you encounter any issues, please refer to the [troubleshooting](#troubleshooting) section at the bottom of this installation guide.

Wether you use the shell script install or the step by step installation guide, first we need to modify the Sudoers file located at `/etc/sudoers` via the `visudo` command:
```bash
visudo
```

Insert the contents below and save the file:
```bash
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Install via shell script:

```bash
wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Rocky9/Shell%20Script/iptablescheck_install.sh | bash
```

Installation guide using step by step instructions:

Create a new file called `iptables.conf` within the `/etc/zabbix/zabbix_agentd.d/` directory:
```bash
nano /etc/zabbix/zabbix_agentd.d/iptables.conf
```

Insert the contents below and save the file:
```bash
##### IPTABLES CHECK #####
UserParameter=iptables-status, sudo /usr/local/bin/iptablescheck.sh
UserParameter=iptables-md5, sudo /sbin/iptables -L INPUT -n | cksum | cut -d " " -f 1
##### IPTABLES CHECK #####
```

Create a new file called `iptablescheck.sh` within the `/usr/local/bin/` directory:
```bash
nano /usr/local/bin/iptablescheck.sh
```

Insert the contents below and save the file:
> [!IMPORTANT]
> Please check which firewall service you are using with your installation and adjust if necessary.
```bash
#!/bin/sh

systemctl is-active --quiet iptables.service >/dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="1"
fi

echo "$ST"
exit $EX
```

Make the file executable:
```bash
chmod +x /usr/local/bin/iptablescheck.sh
```

Restart the Zabbix agent service:
```bash
systemctl restart zabbix-agent
```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Template/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.


## Troubleshooting

Within the Zabbix server admin dashboard GUI, click on **Settings** > **Hosts** > **Items** (of the desired) host and check the following two items and their status. You might run into the following two error messages:

**Template OS Linux - Iptables: iptables is running**
`Value "sudo: sorry, you must have a tty to run sudo" of type "string" is not suitable for value type "Numeric (unsigned)"`

**Template OS Linux - Iptables: iptables policy checksum**<
`Value "sudo: sorry, you must have a tty to run sudo 1234567890" of type "string" is not suitable for value type "Numeric (unsigned)"`

If that happens to be the case, connect to your host and modify the sudoers file with visudo:</br>
```bash
visudo
```

We are looking for an entry which looks as follows:
`Defaults  requiretty`

You can either comment it out and save the file like this:
`# Defaults  requiretty`

Or you can leave it as it is and add the following line below `Defaults  requiretty` and save the file afterwards:
`Defaults:zabbix !requiretty`

Once you are done, restart the Zabbix agent service:
`systemctl restart zabbix-agent`

When done, wait a moment until your item status indicator turns green. If you want to speed things up, change the update timer within the each item.

Credits: https://github.com/thecamels