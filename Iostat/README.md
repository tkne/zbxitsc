iostat check for Zabbix
======

</br>

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

## On CentOS 6.x (with installer shell script)

Check which user config path Zabbix config uses:</br>
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

Run installer shell script:</br>
```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Shell%20Script%20Installers/iostat_install_centos6x.sh | bash```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).

</br>
</br>

## On CentOS 7.x (with installer shell script)

Check which user config path Zabbix config uses:</br>
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

Run installer shell script:</br>
```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Shell%20Script%20Installers/iostat_install_centos7x.sh | bash```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).

</br>
</br>

## On Debian 8.x (with installer shell script)

Check which user config path Zabbix config uses:</br>
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

Run installer shell script:</br>
```$ wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Iostat/Shell%20Script%20Installers/iostat_install_debian8x.sh | bash```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).

</br>
</br>
</br>
</br>

## On CentOS 6.x (manual install)

Create needed folders:</br>
```# mkdir -p /usr/local/zabbix-agent-ops/var/```

Check which user config path Zabbix config uses:</br>
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

Create a new file called ```iostat-params.conf```:</br>
```# nano /etc/zabbix/zabbix_agentd.d/iostat-params.conf```

Insert the contents below and save:
```bash
UserParameter=custom.vfs.dev.discovery,/usr/local/bin/dev-discovery.sh
UserParameter=iostat[*],/usr/local/bin/iostat-check.sh $1 $2
```

Create a new file called ```iostat-cron.conf``` in ```/etc/cron.d/```:</br>
```# nano /etc/cron.d/iostat-cron.conf```
Insert the contents below and save:
```
* * * * * root /usr/local/bin/iostat-cron.sh
```

Create a new file called ```dev-discovery.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/dev-discovery.sh```

Insert the contents below and save:
```bash
#!/bin/bash

DEVICES=`iostat | awk '{ if ($1 ~ "^([shxv]|xv)d[a-z]$") { print $1 } }'`

COUNT=`echo "$DEVICES" | wc -l`
INDEX=0
echo '{"data":['
echo "$DEVICES" | while read LINE; do
    echo -n '{"{#DEVNAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'
```

Create a new file called ```iostat-check.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/iostat-check.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# iostat:
#  - IO
#  - running / blocked processes
#  - swap in / out
#  - block in / out
#
# Info:
#  - vmstat data are gathered via cron job
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/usr/local/zabbix-agent-ops/var/iostat-data

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_DATA_FILE="-0.9900"
ERROR_OLD_DATA="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_MISSING_PARAM="-0.9903"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# Old data handling:
#  - in case the cron can not update the data file
#  - in case the data are too old we want to notify the system
# Consider the data as non-valid if older than OLD_DATA minutes
#
OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi

#
# Grab data from SOURCE_DATA for key ZBX_REQ_DATA
#
# 1st check the device exists and gets data gathered by cron job
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  rrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  wrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  r/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  w/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  rkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  wkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  avgrq-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  avgqu-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  await)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  svctm)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  %util)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $12}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
```

Create a new file called ```iostat-cron.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/iostat-cron.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# Info:
#  - cron job to gather iostat data
#  - can not do real time as iostat data gathering will exceed
#    Zabbix agent timeout
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# source data file
DEST_DATA=/usr/local/zabbix-agent-ops/var/iostat-data
TMP_DATA=/usr/local/zabbix-agent-ops/var/iostat-data.tmp

#
# gather data in temp file first, then move to final location
# it avoids zabbix-agent to gather data from a half written source file
#
# iostat -kx 10 2 - will display 2 lines :
#  - 1st: statistics since boot -- useless
#  - 2nd: statistics over the last 10 sec
#
iostat -kx 10 2 > $TMP_DATA
mv $TMP_DATA $DEST_DATA
```

Make the file executable:</br>
```# chmod +x /usr/local/bin/dev-discovery.sh```
```# chmod +x /usr/local/bin/iostat-check.sh```
```# chmod +x /usr/local/bin/iostat-cron.sh```

Restart Cron service:</br>
```# service crond restart```

Restart Zabbix Agent service:</br>
```# service zabbix-agent restart```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).

</br>
</br>

## On CentOS 7.x (manual install)

Create needed folders:</br>
```# mkdir -p /usr/local/zabbix-agent-ops/var/```

Check which user config path Zabbix config uses:</br>
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

Create a new file called ```iostat-params.conf```:</br>
```# nano /etc/zabbix/zabbix_agentd.d/iostat-params.conf```

Insert the contents below and save:
```bash
UserParameter=custom.vfs.dev.discovery,/usr/local/bin/dev-discovery.sh
UserParameter=iostat[*],/usr/local/bin/iostat-check.sh $1 $2
```

Create a new file called ```iostat-cron.conf``` in ```/etc/cron.d/```:</br>
```# nano /etc/cron.d/iostat-cron.conf```
Insert the contents below and save:
```
* * * * * root /usr/local/bin/iostat-cron.sh
```

Create a new file called ```dev-discovery.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/dev-discovery.sh```

Insert the contents below and save:
```bash
#!/bin/bash

DEVICES=`iostat | awk '{ if ($1 ~ "^([shxv]|xv)d[a-z]$") { print $1 } }'`

COUNT=`echo "$DEVICES" | wc -l`
INDEX=0
echo '{"data":['
echo "$DEVICES" | while read LINE; do
    echo -n '{"{#DEVNAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'
```

Create a new file called ```iostat-check.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/iostat-check.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# iostat:
#  - IO
#  - running / blocked processes
#  - swap in / out
#  - block in / out
#
# Info:
#  - vmstat data are gathered via cron job
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/usr/local/zabbix-agent-ops/var/iostat-data

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_DATA_FILE="-0.9900"
ERROR_OLD_DATA="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_MISSING_PARAM="-0.9903"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# Old data handling:
#  - in case the cron can not update the data file
#  - in case the data are too old we want to notify the system
# Consider the data as non-valid if older than OLD_DATA minutes
#
OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi

#
# Grab data from SOURCE_DATA for key ZBX_REQ_DATA
#
# 1st check the device exists and gets data gathered by cron job
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  rrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  wrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  r/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  w/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  rkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  wkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  avgrq-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  avgqu-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  await)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  svctm)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  %util)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $12}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
```

Create a new file called ```iostat-cron.sh``` in ```/usr/local/bin/```:</br>
```# nano /usr/local/bin/iostat-cron.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# Info:
#  - cron job to gather iostat data
#  - can not do real time as iostat data gathering will exceed
#    Zabbix agent timeout
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# source data file
DEST_DATA=/usr/local/zabbix-agent-ops/var/iostat-data
TMP_DATA=/usr/local/zabbix-agent-ops/var/iostat-data.tmp

#
# gather data in temp file first, then move to final location
# it avoids zabbix-agent to gather data from a half written source file
#
# iostat -kx 10 2 - will display 2 lines :
#  - 1st: statistics since boot -- useless
#  - 2nd: statistics over the last 10 sec
#
iostat -kx 10 2 > $TMP_DATA
mv $TMP_DATA $DEST_DATA
```

Make the file executable:</br>
```# chmod +x /usr/local/bin/dev-discovery.sh```
```# chmod +x /usr/local/bin/iostat-check.sh```
```# chmod +x /usr/local/bin/iostat-cron.sh```

Restart Cron service:</br>
```# systemctl status crond```

Restart Zabbix Agent service:</br>
```# systemctl restart zabbix-agent```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).

</br>
</br>

## On Debian 8.x (manual install)

Create needed folders:</br>
```$ mkdir -p /usr/local/zabbix-agent-ops/var/```

Check which user config path Zabbix config uses:</br>
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

Create a new file called ```iostat-params.conf```:</br>
```$ nano /usr/local/etc/zabbix_agentd.conf.d/iostat-params.conf```

Insert the contents below and save:
```bash
UserParameter=custom.vfs.dev.discovery,/usr/local/bin/dev-discovery.sh
UserParameter=iostat[*],/usr/local/bin/iostat-check.sh $1 $2
```

Create a new file called ```iostat-cron.conf``` in ```/etc/cron.d/```:</br>
```$ nano /etc/cron.d/iostat-cron.conf```
Insert the contents below and save:
```
* * * * * root /usr/local/bin/iostat-cron.sh
```

Create a new file called ```dev-discovery.sh``` in ```/usr/local/bin/```:</br>
```$ nano /usr/local/bin/dev-discovery.sh```

Insert the contents below and save:
```bash
#!/bin/bash

DEVICES=`iostat | awk '{ if ($1 ~ "^([shxv]|xv)d[a-z]$") { print $1 } }'`

COUNT=`echo "$DEVICES" | wc -l`
INDEX=0
echo '{"data":['
echo "$DEVICES" | while read LINE; do
    echo -n '{"{#DEVNAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'
```

Create a new file called ```iostat-check.sh``` in ```/usr/local/bin/```:</br>
```$ nano /usr/local/bin/iostat-check.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# iostat:
#  - IO
#  - running / blocked processes
#  - swap in / out
#  - block in / out
#
# Info:
#  - vmstat data are gathered via cron job
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/usr/local/zabbix-agent-ops/var/iostat-data

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_DATA_FILE="-0.9900"
ERROR_OLD_DATA="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_MISSING_PARAM="-0.9903"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# Old data handling:
#  - in case the cron can not update the data file
#  - in case the data are too old we want to notify the system
# Consider the data as non-valid if older than OLD_DATA minutes
#
OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi

#
# Grab data from SOURCE_DATA for key ZBX_REQ_DATA
#
# 1st check the device exists and gets data gathered by cron job
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  rrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  wrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  r/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  w/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  rkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  wkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  avgrq-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  avgqu-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  await)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  svctm)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  %util)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $12}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
```

Create a new file called ```iostat-cron.sh``` in ```/usr/local/bin/```:</br>
```$ nano /usr/local/bin/iostat-cron.sh```

Insert the contents below and save:
```bash
#!/bin/bash
##################################
# Zabbix monitoring script
#
# Info:
#  - cron job to gather iostat data
#  - can not do real time as iostat data gathering will exceed
#    Zabbix agent timeout
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# source data file
DEST_DATA=/usr/local/zabbix-agent-ops/var/iostat-data
TMP_DATA=/usr/local/zabbix-agent-ops/var/iostat-data.tmp

#
# gather data in temp file first, then move to final location
# it avoids zabbix-agent to gather data from a half written source file
#
# iostat -kx 10 2 - will display 2 lines :
#  - 1st: statistics since boot -- useless
#  - 2nd: statistics over the last 10 sec
#
iostat -kx 10 2 > $TMP_DATA
mv $TMP_DATA $DEST_DATA
```

Make the file executable:</br>
```$ chmod +x /usr/local/bin/dev-discovery.sh```
```$ chmod +x /usr/local/bin/iostat-check.sh```
```$ chmod +x /usr/local/bin/iostat-cron.sh```

Restart Cron service:</br>
```$ service cron restart```

Restart Zabbix Agent service:</br>
```$ service zabbix-agent restart```

When done, import the [**Template iostat**](https://github.com/tkne/zbxitsc/blob/master/Iostat/Template/iostat-template.xml).
</br>
</br>
</br>
Credits: https://github.com/jizhang & https://github.com/zbal