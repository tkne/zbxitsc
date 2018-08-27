Total Monthly Bandwidth check for Zabbix (with additional monthly mail report)
======

   * [On CentOS 6.x](#on-centos-6x)
   * [On CentOS 7.x](#on-centos-7x)
   * [On Debian 8.x](#on-debian-8x)

</br>
</br>
</br>

## On CentOS 6.x

Install vnstat, bc & mutt:</br>
```# yum -y install vnstat bc mutt```

Check network adapter name:</br>
```# netstat -i```

Output:
```bash
Iface       MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
em1        1500  120483015      0   1829 0      114781021      0      0      0 BMRU
lo        65536    8031477      0      0 0        8031477      0      0      0 LRU
```

Change network adapter settings (default is "eth0") if needed:</br>
```# nano /etc/sysconfig/vnstat```

Contents:
```bash
# see also: vnstat(1)
#
# starting with vnstat-1.6 vnstat can also be
# configured via /etc/vnstat.conf
#
# the following sets vnstat up to monitor eth0
VNSTAT_OPTIONS="-u -i em1"

...

...

```

```# nano /etc/vnstat.conf```

Contents:
```bash
# default interface
Interface "em1"
```

Create vnstat database:</br>
```# vnstat -u -i em1```

Start vnstatd service:</br>
```# service vnstat start```

Enable vnstatd service on start-up:</br>
```# chkconfig vnstat on```

Check monthly vnstat output:</br>
```# vnstat -m```

Output:
```bash
 em1  /  monthly

       month        rx      |     tx      |    total    |   avg. rate
    ------------------------+-------------+-------------+---------------
      Aug '18      4.62 MiB |    9.65 MiB |   14.28 MiB |    0.06 kbit/s
    ------------------------+-------------+-------------+---------------
    estimated         5 MiB |      11 MiB |      16 MiB |
```
If there is no output yet, use "# vnstat -u" to update database with populated data.

Check which user config path Zabbix config uses:</br>
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/etc/zabbix/zabbix_agentd.d/```.

Create userparameter config:</br>
```# nano /etc/zabbix/zabbix_agentd.d/total_monthly_traffic.conf```

Contents:
```bash
############################### Total Monthly Traffic ###############################
UserParameter=system.monthlybandwidth, /usr/local/bin/zbx_total_monthly_traffic.sh
```

Create monthly total bandwidth script:</br>
```# nano /usr/local/bin/zbx_total_monthly_traffic.sh```

Contents:
```bash
#!/bin/bash
    # Current month total bandwidth in MB

    i=$(vnstat --oneline | awk -F\; '{ print $11 }')

    bandwidth_number=$(echo $i | awk '{ print $1 }')
    bandwidth_unit=$(echo $i | awk '{ print $2 }')

    case "$bandwidth_unit" in
    KiB)    bandwidth_number_MB=$(echo "$bandwidth_number/1024" | bc)
        ;;
    MiB)    bandwidth_number_MB=$bandwidth_number
        ;;
    GiB)     bandwidth_number_MB=$(echo "$bandwidth_number*1024" | bc)
        ;;
    TiB)    bandwidth_number_MB=$(echo "$bandwidth_number*1024*1024" | bc)
        ;;
    esac

echo $bandwidth_number_MB
```

Make shell script executable:</br>
```# chmod +x /usr/local/bin/zbx_total_monthly_traffic.sh```

Restart Zabbix agent:</br>
```# service zabbix-agent restart```

Create folder for monthly vnstati graph:</br>
```# mkdir /etc/vnstati_graph```

Add cronjobs:</br>
 * Update database every 5 minutes
 * Create monthly bandwidth summary graph on every 1st day of a month at 00:05
 * Send mail with monthly graph attachment on every 1st day of a month at 00:10

```# nano /etc/crontab```

Contents:
```bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

0-55/5 * * * * root /usr/bin/vnstat -u
05 00 01 * * root /usr/bin/vnstati -m -i em1 -o /etc/vnstati_graph/monthly_summary.png
10 00 01 * * root /usr/bin/mutt -s "SRV-01 - Total Monthly Bandwidth" your@mail.com -F /dev/null < /dev/null -a /etc/vnstati_graph/monthly_summary.png
```

Restart crond service:</br>
```# service crond restart```

Next, import the [**Template Bandwidth**](https://github.com/tkne/zbxitsc/blob/master/Bandwidth/Template/Template%20Bandwidth.xml) and your're good to go.

When done, you will have screen graphs like this:</br>

![zbx_srv_traffic](https://imgur.com/HR8rIkN.jpg)

And a graph sent to you every month by mail that looks like this:</br>

![monthly_summary](https://imgur.com/QiH3h0S.jpg)

</br>
</br>

## On CentOS 7.x

Install vnstat, bc & mutt:</br>
```# yum -y install vnstat bc mutt```

Check network adapter name:</br>
```# netstat -i```

Output:
```bash
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
ens192    1500 120483015      0   1829 0      114781021      0      0      0 BMRU
lo       65536  8031477       0      0 0        8031477      0      0      0 LRU
```

Change network adapter settings (default is "eth0") if needed:</br>
```# nano /etc/sysconfig/vnstat```

Contents:
```bash
# see also: vnstat(1)
#
# starting with vnstat-1.6 vnstat can also be
# configured via /etc/vnstat.conf
#
# the following sets vnstat up to monitor eth0
VNSTAT_OPTIONS="-u -i ens192"

...

...

```

```# nano /etc/vnstat.conf```

Contents:
```bash
# default interface
Interface "ens192"
```

Create vnstat database:</br>
```# vnstat -u -i ens192```

Start vnstatd service:</br>
```# systemctl start vnstat```

Enable vnstatd servic on start-up:</br>
```# systemctl enable vnstat```

Check monthly vnstat output:</br>
```# vnstat -m```

Output:
```bash
 ens192  /  monthly

       month        rx      |     tx      |    total    |   avg. rate
    ------------------------+-------------+-------------+---------------
      Aug '18      4.62 MiB |    9.65 MiB |   14.28 MiB |    0.06 kbit/s
    ------------------------+-------------+-------------+---------------
    estimated         5 MiB |      11 MiB |      16 MiB |
```
If there is no output yet, use "# vnstat -u" to update database with populated data.

Check which user config path Zabbix config uses:</br>
```# cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Output:
```bash
### Option: Include
# Include=
Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/etc/zabbix/zabbix_agentd.d/```.

Create userparameter config:</br>
```# nano /etc/zabbix/zabbix_agentd.d/total_monthly_traffic.conf```

Contents:
```bash
############################### Total Monthly Traffic ###############################
UserParameter=system.monthlybandwidth, /usr/local/bin/zbx_total_monthly_traffic.sh
```

Create monthly total bandwidth script:</br>
```# nano /usr/local/bin/zbx_total_monthly_traffic.sh```

Contents:
```bash
#!/bin/bash
    # Current month total bandwidth in MB

    i=$(vnstat --oneline | awk -F\; '{ print $11 }')

    bandwidth_number=$(echo $i | awk '{ print $1 }')
    bandwidth_unit=$(echo $i | awk '{ print $2 }')

    case "$bandwidth_unit" in
    KiB)    bandwidth_number_MB=$(echo "$bandwidth_number/1024" | bc)
        ;;
    MiB)    bandwidth_number_MB=$bandwidth_number
        ;;
    GiB)     bandwidth_number_MB=$(echo "$bandwidth_number*1024" | bc)
        ;;
    TiB)    bandwidth_number_MB=$(echo "$bandwidth_number*1024*1024" | bc)
        ;;
    esac

echo $bandwidth_number_MB
```

Make shell script executable:</br>
```# chmod +x /usr/local/bin/zbx_total_monthly_traffic.sh```

Restart Zabbix agent:</br>
```# systemctl start zabbix-agent```

Create folder for monthly vnstati graph:</br>
```# mkdir /etc/vnstati_graph```

Add cronjobs:</br>
 * Update database every 5 minutes
 * Create monthly bandwidth summary graph on every 1st day of a month at 00:05
 * Send mail with monthly graph attachment on every 1st day of a month at 00:10

```# nano /etc/crontab```

Contents:
```bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

0-55/5 * * * * root /usr/bin/vnstat -u
05 00 01 * * root /usr/bin/vnstati -m -i em1 -o /etc/vnstati_graph/monthly_summary.png
10 00 01 * * root /usr/bin/mutt -s "SRV-01 - Total Monthly Bandwidth" your@mail.com -F /dev/null < /dev/null -a /etc/vnstati_graph/monthly_summary.png
```

Restart crond service:</br>
```# systemctl restart crond```

Next, import the [**Template Bandwidth**](https://github.com/tkne/zbxitsc/blob/master/Bandwidth/Template/Template%20Bandwidth.xml) and your're good to go.

When done, you will have screen graphs like this:</br>

![zbx_srv_traffic](https://imgur.com/HR8rIkN.jpg)

And a graph sent to you every month by mail that looks like this:</br>

![monthly_summary](https://imgur.com/QiH3h0S.jpg)

</br>
</br>

## On Debian 8.x

Install vnstat, bc & mutt:</br>
```$ apt-get -y install vnstat bc mutt```

Check network adapter name:</br>
```$ netstat -i```

Output:
```bash
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0      1500 120483015      0   1829 0      114781021      0      0      0 BMRU
lo       65536   8031477      0      0 0        8031477      0      0      0 LRU
```

Change network adapter settings (default is "eth0") if needed:</br>
```$ nano /etc/sysconfig/vnstat```

Contents:
```bash
# see also: vnstat(1)
#
# starting with vnstat-1.6 vnstat can also be
# configured via /etc/vnstat.conf
#
# the following sets vnstat up to monitor eth0
VNSTAT_OPTIONS="-u -i eth0"

...

...

```

```$ nano /etc/vnstat.conf```

Contents:
```bash
# default interface
Interface "eth0"
```

Create vnstat database:</br>
```$ vnstat -u -i eth0```

Start vnstatd service:</br>
```$ service vnstat start```

Enable vnstatd service on start-up:</br>
```$ chkconfig vnstat on```

Check monthly vnstat output:</br>
```$ vnstat -m```

Output:
```bash
 eth0  /  monthly

       month        rx      |     tx      |    total    |   avg. rate
    ------------------------+-------------+-------------+---------------
      Aug '18      4.62 MiB |    9.65 MiB |   14.28 MiB |    0.06 kbit/s
    ------------------------+-------------+-------------+---------------
    estimated         5 MiB |      11 MiB |      16 MiB |
```
If there is no output yet, use "# vnstat -u" to update database with populated data.

Check which user config path Zabbix config uses:</br>
```$ cat /etc/zabbix/zabbix_agentd.conf | grep Include```

Output:
```bash
### Option: Include
# Include=
# Include=/etc/zabbix/zabbix_agentd.d/*.conf
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
Include=/usr/local/etc/zabbix_agentd.conf.d/
# Include=/usr/local/etc/zabbix_agentd.conf.d/*.conf
```

In my case we are going to use ```Include=/usr/local/etc/zabbix_agentd.conf.d/```.

Create userparameter config:</br>
```$ nano /etc/zabbix/zabbix_agentd.conf.d/total_monthly_traffic.conf```

Contents:
```bash
############################### Total Monthly Traffic ###############################
UserParameter=system.monthlybandwidth, /usr/local/bin/zbx_total_monthly_traffic.sh
```

Create monthly total bandwidth script:</br>
```$ nano /usr/local/bin/zbx_total_monthly_traffic.sh```

Contents:
```bash
#!/bin/bash
    # Current month total bandwidth in MB

    i=$(vnstat --oneline | awk -F\; '{ print $11 }')

    bandwidth_number=$(echo $i | awk '{ print $1 }')
    bandwidth_unit=$(echo $i | awk '{ print $2 }')

    case "$bandwidth_unit" in
    KiB)    bandwidth_number_MB=$(echo "$bandwidth_number/1024" | bc)
        ;;
    MiB)    bandwidth_number_MB=$bandwidth_number
        ;;
    GiB)     bandwidth_number_MB=$(echo "$bandwidth_number*1024" | bc)
        ;;
    TiB)    bandwidth_number_MB=$(echo "$bandwidth_number*1024*1024" | bc)
        ;;
    esac

echo $bandwidth_number_MB
```

Make shell script executable:</br>
```$ chmod +x /usr/local/bin/zbx_total_monthly_traffic.sh```

Restart Zabbix agent:</br>
```$ service zabbix-agent restart```

Create folder for monthly vnstati graph:</br>
```$ mkdir /etc/vnstati_graph```

Add cronjobs:</br>
 * Update database every 5 minutes
 * Create monthly bandwidth summary graph on every 1st day of a month at 00:05
 * Send mail with monthly graph attachment on every 1st day of a month at 00:10

```$ nano /etc/crontab```

Contents:
```bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

0-55/5 * * * * root /usr/bin/vnstat -u
05 00 01 * * root /usr/bin/vnstati -m -i em1 -o /etc/vnstati_graph/monthly_summary.png
10 00 01 * * root /usr/bin/mutt -s "SRV-01 - Total Monthly Bandwidth" your@mail.com -F /dev/null < /dev/null -a /etc/vnstati_graph/monthly_summary.png
```

Restart crond service:</br>
```$ service crond restart```

Next, import the [**Template Bandwidth**](https://github.com/tkne/zbxitsc/blob/master/Bandwidth/Template/Template%20Bandwidth.xml) and your're good to go.

When done, you will have screen graphs like this:</br>

![zbx_srv_traffic](https://imgur.com/HR8rIkN.jpg)

And a graph sent to you every month by mail that looks like this:</br>

![monthly_summary](https://imgur.com/QiH3h0S.jpg)
</br>
</br>
</br>
Credits: https://github.com/thecamels