Iptables status check for Zabbix
======

Installation guide using installer shell script

   * [On CentOS 6.x](#on-centos-6x-with-installer-shell-script)
   * [On CentOS 7.x](#on-centos-7x-with-installer-shell-script)
   * [On Debian 8.x](#on-debian-8x-with-installer-shell-script)


Installation guide using step by step instructions **without** using installer shell script

   * [On CentOS 6.x](#on-centos-6x-manual-install)
   * [On CentOS 7.x](#on-centos-7x-manual-install)
   * [On Debian 8.x](#on-debian-8x-manual-install)

</br>
</br>
</br>
</br>

## On CentOS 6.x (with installer shell script)

Open sudoers file in the editor:
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses: 
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/etc/zabbix/zabbix_agentd.d/*.conf``` or ```Include=/etc/zabbix/zabbix_agentd.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_centos6x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.

</br>
</br>

## On CentOS 7.x (with installer shell script)

Open sudoers file in the editor:
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses: 
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/etc/zabbix/zabbix_agentd.d/*.conf``` or ```Include=/etc/zabbix/zabbix_agentd.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_centos7x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.

</br>
</br>

## On Debian 8.x (with installer shell script)

Open sudoers file in the editor:
```$ nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses: 
```$ cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
#Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf``` or ```Include=/usr/local/etc/zabbix_agentd.conf.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```$ wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_debian8x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.

</br>
</br>
</br>
</br>

## On CentOS 6.x (manual install)

Open sudoers file in the editor:
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses:
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/etc/zabbix/zabbix_agentd.d/```.

Create a new file called ```iptables.conf```:
```# nano /etc/zabbix/zabbix_agentd.conf.d/iptables.conf```

Insert the contents below and save:
```
##### IPTABLES CHECK #####
UserParameter=iptables-status, sudo /usr/local/bin/iptablescheck.sh
UserParameter=iptables-md5, sudo /sbin/iptables -L INPUT -n | cksum | cut -d " " -f 1
##### IPTABLES CHECK #####
```

Create a new file called ```iptablescheck.sh``` in ```/usr/local/bin/```:
```# nano /usr/local/bin/iptablescheck.sh```

Insert the contents below and save:
```bash
#!/bin/sh

grep filter /proc/net/ip_tables_names  > /dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="2"
fi

echo "$ST"
exit $EX
```

Make the file executable:
```# chmod +x /usr/local/bin/iptablescheck.sh```

Restart Zabbix agent service:
```# service zabbix-agent restart```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.

</br>
</br>

## On CentOS 7.x (manual install)

Open sudoers file in the editor:
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses:
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/etc/zabbix/zabbix_agentd.d/```.

Create a new file called ```iptables.conf```:
```# nano /etc/zabbix/zabbix_agentd.conf.d/iptables.conf```

Insert the contents below and save:
```
##### IPTABLES CHECK #####
UserParameter=iptables-status, sudo /usr/local/bin/iptablescheck.sh
UserParameter=iptables-md5, sudo /sbin/iptables -L INPUT -n | cksum | cut -d " " -f 1
##### IPTABLES CHECK #####
```

Create a new file called ```iptablescheck.sh``` in ```/usr/local/bin/```:
```# nano /usr/local/bin/iptablescheck.sh```

Insert the contents below and save:
```bash
#!/bin/sh

grep filter /proc/net/ip_tables_names  > /dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="2"
fi

echo "$ST"
exit $EX
```

Make the file executable:
```# chmod +x /usr/local/bin/iptablescheck.sh```

Restart Zabbix agent service:
```# systemctl restart zabbix-agent```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.

</br>
</br>

## On Debian 8.x (manual install)

Open sudoers file in the editor:
```$ nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

Check which user config path Zabbix config uses:
```$ cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```bash
### Option: Include
# Include=
#Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/usr/local/etc/zabbix_agentd.conf.d/```.

Create a new file called ```iptables.conf```:
```$ nano /usr/local/etc/zabbix_agentd.conf.d/iptables.conf```

Insert the contents below and save:
```
##### IPTABLES CHECK #####
UserParameter=iptables-status, sudo /usr/local/bin/iptablescheck.sh
UserParameter=iptables-md5, sudo /sbin/iptables -L INPUT -n | cksum | cut -d " " -f 1
##### IPTABLES CHECK #####
```

Create a new file called ```iptablescheck.sh``` in ```/usr/local/bin/```:
```$ nano /usr/local/bin/iptablescheck.sh```

Insert the contents below and save:
```bash
#!/bin/sh

grep filter /proc/net/ip_tables_names  > /dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="2"
fi

echo "$ST"
exit $EX
```

Make the file executable:
```$ chmod +x /usr/local/bin/iptablescheck.sh```

Restart Zabbix agent service:
```$ service zabbix-agent restart```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.