Iptables status check for Zabbix
======

Installation manual using installer shell script.




## On CentOS 6.x:

Open sudoers file in the editor (I'm using nano here. Choose whatever you feel comfortable with.)
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

- Check which user config path Zabbix config uses: 
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```
### Option: Include
# Include=
**Include=/etc/zabbix/zabbix_agentd.d/*.conf**
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/etc/zabbix/zabbix_agentd.d/*.conf``` or ```Include=/etc/zabbix/zabbix_agentd.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_centos6x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.




## On CentOS 7.x:

Open sudoers file in the editor (I'm using nano here. Choose whatever you feel comfortable with.)
```# nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

- Check which user config path Zabbix config uses: 
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```
### Option: Include
# Include=
**Include=/etc/zabbix/zabbix_agentd.d/*.conf**
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/etc/zabbix/zabbix_agentd.d/*.conf``` or ```Include=/etc/zabbix/zabbix_agentd.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_centos7x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.




## On Debian 8.x:

Open sudoers file in the editor (I'm using nano here. Choose whatever you feel comfortable with.)
```$ nano /etc/sudoers```

Add the following:
```
zabbix  ALL=(ALL)       NOPASSWD: /sbin/iptables -L INPUT -n
zabbix  ALL=(ALL)       NOPASSWD: /usr/local/bin/iptablescheck.sh
```

- Check which user config path Zabbix config uses: 
```$ cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Example output:
```
### Option: Include
# Include=
#Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
**Include=/usr/local/etc/zabbix_agentd.conf.d/**
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

If ```Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf``` or ```Include=/usr/local/etc/zabbix_agentd.conf.d/``` matches your output, proceed using the script below. Otherwise edit the script to match your path of choice.

```$ wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iptables/Shell%20Script%20Installers/iptablescheck_install_debian8x.sh | bash```

When done, import the [**Template Linux OS - Iptables template**](https://github.com/tkne/zbxitsc/blob/master/Iptables/Templates/Template%20Linux%20OS%20-%20Iptables.xml) and your're good to go.