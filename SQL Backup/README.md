SQL database backup for Zabbix
======

Installation guide

   * [On CentOS 6.x](#on-centos-6x)
   * [On CentOS 7.x](#on-centos-7x)

</br>
</br>
</br>

## On CentOS 6.x

**On Zabbix server:**

Download Percona XtraBackup:</br>
(Check https://www.percona.com/downloads/XtraBackup/LATEST/ for latest build)</br>
```# wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/binary/redhat/6/x86_64/percona-xtrabackup-24-2.4.12-1.el6.x86_64.rpm```

Install Percona XtraBackup:</br>
```# yum -y install percona-xtrabackup-24-2.4.12-1.el6.x86_64.rpm```

Create backup folders:</br>
```# mkdir -p /var/lib/xtrabackup/backup```

Create backup script:</br>
```# nano /var/lib/xtrabackup/mysql-fullbackup.sh```

Insert the following content (please update **MYSQLUSER**, **MYSQLPASS**, **MYSQLCNF**, **MYSQLDIR**, **ZBXSRVCNF** & **ZBXAGTCNF** with your sql user credentials and according folder paths):</br>
```bash
#!/bin/bash
#
MYSQLUSER="USERNAME"
MYSQLPASS="PASSWORD"

MYSQLCNF="/etc/my.cnf"
MYSQLDIR="/var/lib/mysql"

ZBXSRVCNF="/etc/zabbix/zabbix_server.conf"
ZBXAGTCNF="/etc/zabbix/zabbix_agentd.conf"

BASEDIR="/var/lib/xtrabackup/backup"
BKPDIR="${BASEDIR}/lastbackup_$(date +%Y%m%d-%H%M)"
BKPTEMPDIR="${BASEDIR}/tempbackup"

# Memory used in stage 2
USEMEMORY="1GB"

# create basedir
mkdir -p ${BASEDIR}

# remove temporary dir
if [ -d "${BKPTEMPDIR}" ]; then
        rm -rf ${BKPTEMPDIR}
fi

# do backup - stage 1
innobackupex --defaults-file=${MYSQLCNF} --user=${MYSQLUSER} --no-timestamp --password=${MYSQLPASS} ${BKPTEMPDIR}

# do backup - stage 2 (prepare backup for restore)
innobackupex --apply-log --use-memory=${USEMEMORY} ${BKPTEMPDIR}

# backup my.cnf
cp -pf ${MYSQLCNF} ${BKPTEMPDIR}/my.cnf

# backup zabbix_server.conf
cp -pf ${ZBXSRVCNF} ${BKPTEMPDIR}/zabbix_server.conf

# backup zabbix_agentd.conf
cp -pf ${ZBXAGTCNF} ${BKPTEMPDIR}/zabbix_agentd.conf

chown -R mysql: ${BKPTEMPDIR}
mv ${BKPTEMPDIR} ${BKPDIR}
tar -czvf ${BKPDIR}.tar.gz ${BKPDIR}
```

Make shell script executable:</br>
```# chmod +x /var/lib/xtrabackup/mysql-fullbackup.sh```

Test the shell script:</br>
```# sh /var/lib/xtrabackup/mysql-fullbackup.sh```

Check your results:</br>
```# ls -la /var/lib/xtrabackup/backup/```

</br>
</br>

**Cronjob settings on Zabbix server:**

Open crontab in editor:</br>
```# nano /etc/crontab```

Edit crontab to automatically create backups and remove backups older than one day:</br> 
```
00 08 * * * root find /var/lib/xtrabackup/backup/* -maxdepth 0 -exec rm -rf {} +
00 01 * * * root /var/lib/xtrabackup/mysql-fullbackup.sh >/var/lib/xtrabackup/lastrun.log 2>&1
```

Restart crond service:</br>
```# service crond restart```

</br>
</br>

**Backup host Cronjob settings:****

Open crontab in editor:</br>
```# nano /etc/crontab```
```
00 08 * * * root find /srv01_backup/* -maxdepth 0 -mtime +6 -exec rm -rf {} +
00 02 * * * root rsync -acvzh --remove-source-files root@<YOURIPADDRESS>:/var/lib/xtrabackup/backup/*.tar.gz /srv01_backup
```

Restart crond service:</br>
```# service crond restart```

</br>
</br>

**EXTRA: Private IP server to private IP server via public IP server hop**

Example:

Backup host  = srvA // 10.0.0.1
Hop server   = srvB // 2.2.2.2
Local backup = srvC // 10.1.1.1

We want to grab the backup file from host srvC and transfer it over to srvA via a srvB hop connection.


**On srvA // 10.0.0.1**

Create key pair:</br>
```# ssh-keygen```
```
OUTPUT:
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa): << Press ENTER
```
```
OUTPUT:
Enter passphrase (empty for no passphrase): << Press ENTER for no passphrase
```

Connect to public hop server srvB for authentification:</br>
```# ssh-copy-id root@2.2.2.2```
```
OUTPUT:
The authenticity of host '2.2.2.2 (2.2.2.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
```
OUTPUT:
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@2.2.2.2's password: << Enter "username" password and press ENTER
```
```
OUTPUT:
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@2.2.2.2'"
and check to make sure that only the key(s) you wanted were added.
```

Check if connection to public hop server srvB works:</br>
```# ssh root@2.2.2.2```
```
OUTPUT:
The authenticity of host '2.2.2.2 (2.2.2.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
If successfully connected get root access or sudo and repeat same procedure on srvB to connect to server C

</br>
</br>

**On srvB // 2.2.2.2**

Create key pair:</br>
```# ssh-keygen```
```
OUTPUT:
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa): << Press ENTER
```
```
OUTPUT:
Enter passphrase (empty for no passphrase): << Press ENTER for no passphrase
```

Connect to srvC for authentification:</br>
```# ssh-copy-id root@10.1.1.1```
```
OUTPUT:
The authenticity of host '10.1.1.1 (10.1.1.1)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
```
OUTPUT:
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@10.1.1.1's password: << Enter "username" password and press ENTER
```
```
OUTPUT:
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@10.1.1.1'"
and check to make sure that only the key(s) you wanted were added.
```

Check if connection to srvC works:</br>
```# ssh root@10.1.1.1```
```
OUTPUT:
The authenticity of host '10.1.1.1 (10.1.1.1)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
If successful log out and log back in to server A to test transferring the backup file from server C to server A

</br>
</br>

**On server A // 10.0.0.1**

Test file transfer from server C to server A:</br>
```# rsync -acvzh -e "ssh -A root@2.2.2.2 ssh" --remove-source-files root@10.1.1.1:/var/lib/xtrabackup/backup/*.tar.gz /srvC_backup```


**Backup host Cronjob settings:****

Open crontab in editor:</br>
```# nano /etc/crontab```
```
00 12 * * * root find /srvC_backup/* -maxdepth 0 -mtime +6 -exec rm -rf {} +
30 02 * * * root rsync -acvzh --remove-source-files root@10.1.1.1:/var/lib/xtrabackup/backup/*.tar.gz /srvC_backup
```

Restart crond service:</br>
```# service crond restart```

</br>
</br>

**Zabbix SQL database restore procedure**

Stop the MySQL service:</br>
```# service mysql stop```

Move backup files:</br>
```# cd /var/lib```
```# mv mysql mysqlcrashed```
```# mv xtrabackup/lastbackup mysql```

Start the MySQL service:</br>
```# service mysql start```

**Congrats!** You're done.

</br>
</br>
</br>
</br>

## On CentOS 7.x

**On Zabbix server:**

Download Percona XtraBackup:</br>
(Check https://www.percona.com/downloads/XtraBackup/LATEST/ for latest build)</br>
```# wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.12-1.el7.x86_64.rpm```

Install Percona XtraBackup:</br>
```# yum -y install percona-xtrabackup-24-2.4.12-1.el7.x86_64.rpm```

Create backup folders:</br>
```# mkdir -p /var/lib/xtrabackup/backup```

Create backup script:</br>
```# nano /var/lib/xtrabackup/mysql-fullbackup.sh```

Insert the following content (please update **MYSQLUSER**, **MYSQLPASS**, **MYSQLCNF**, **MYSQLDIR**, **ZBXSRVCNF** & **ZBXAGTCNF** with your sql user credentials and according folder paths):</br>
```bash
#!/bin/bash
#
MYSQLUSER="USERNAME"
MYSQLPASS="PASSWORD"

MYSQLCNF="/etc/my.cnf"
MYSQLDIR="/var/lib/mysql"

ZBXSRVCNF="/etc/zabbix/zabbix_server.conf"
ZBXAGTCNF="/etc/zabbix/zabbix_agentd.conf"

BASEDIR="/var/lib/xtrabackup/backup"
BKPDIR="${BASEDIR}/lastbackup_$(date +%Y%m%d-%H%M)"
BKPTEMPDIR="${BASEDIR}/tempbackup"

# Memory used in stage 2
USEMEMORY="1GB"

# create basedir
mkdir -p ${BASEDIR}

# remove temporary dir
if [ -d "${BKPTEMPDIR}" ]; then
        rm -rf ${BKPTEMPDIR}
fi

# do backup - stage 1
innobackupex --defaults-file=${MYSQLCNF} --user=${MYSQLUSER} --no-timestamp --password=${MYSQLPASS} ${BKPTEMPDIR}

# do backup - stage 2 (prepare backup for restore)
innobackupex --apply-log --use-memory=${USEMEMORY} ${BKPTEMPDIR}

# backup my.cnf
cp -pf ${MYSQLCNF} ${BKPTEMPDIR}/my.cnf

# backup zabbix_server.conf
cp -pf ${ZBXSRVCNF} ${BKPTEMPDIR}/zabbix_server.conf

# backup zabbix_agentd.conf
cp -pf ${ZBXAGTCNF} ${BKPTEMPDIR}/zabbix_agentd.conf

chown -R mysql: ${BKPTEMPDIR}
mv ${BKPTEMPDIR} ${BKPDIR}
tar -czvf ${BKPDIR}.tar.gz ${BKPDIR}
```

Make shell script executable:</br>
```# chmod +x /var/lib/xtrabackup/mysql-fullbackup.sh```

Test the shell script:</br>
```# sh /var/lib/xtrabackup/mysql-fullbackup.sh```

Check your results:</br>
```# ls -la /var/lib/xtrabackup/backup/```

</br>
</br>

**Cronjob settings on Zabbix server:**

Open crontab in editor:</br>
```# nano /etc/crontab```

Edit crontab to automatically create backups and remove backups older than one day:</br> 
```
00 08 * * * root find /var/lib/xtrabackup/backup/* -maxdepth 0 -exec rm -rf {} +
00 01 * * * root /var/lib/xtrabackup/mysql-fullbackup.sh >/var/lib/xtrabackup/lastrun.log 2>&1
```

Restart crond service:</br>
```# systemctl restart crond```

</br>
</br>

**Backup host Cronjob settings:****

Open crontab in editor:</br>
```# nano /etc/crontab```
```
00 08 * * * root find /srv01_backup/* -maxdepth 0 -mtime +6 -exec rm -rf {} +
00 02 * * * root rsync -acvzh --remove-source-files root@<YOURIPADDRESS>:/var/lib/xtrabackup/backup/*.tar.gz /srv01_backup
```

Restart crond service:</br>
```# systemctl restart crond```

</br>
</br>

**EXTRA: Private IP server to private IP server via public IP server hop**

Example:

Backup host  = srvA // 10.0.0.1
Hop server   = srvB // 2.2.2.2
Local backup = srvC // 10.1.1.1

We want to grab the backup file from host srvC and transfer it over to srvA via a srvB hop connection.


**On srvA // 10.0.0.1**

Create key pair:</br>
```# ssh-keygen```
```
OUTPUT:
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa): << Press ENTER
```
```
OUTPUT:
Enter passphrase (empty for no passphrase): << Press ENTER for no passphrase
```

Connect to public hop server srvB for authentification:</br>
```# ssh-copy-id root@2.2.2.2```
```
OUTPUT:
The authenticity of host '2.2.2.2 (2.2.2.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
```
OUTPUT:
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@2.2.2.2's password: << Enter "username" password and press ENTER
```
```
OUTPUT:
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@2.2.2.2'"
and check to make sure that only the key(s) you wanted were added.
```

Check if connection to public hop server srvB works:</br>
```# ssh root@2.2.2.2```
```
OUTPUT:
The authenticity of host '2.2.2.2 (2.2.2.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
If successfully connected get root access or sudo and repeat same procedure on srvB to connect to server C

</br>
</br>

**On srvB // 2.2.2.2**

Create key pair:</br>
```# ssh-keygen```
```
OUTPUT:
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa): << Press ENTER
```
```
OUTPUT:
Enter passphrase (empty for no passphrase): << Press ENTER for no passphrase
```

Connect to srvC for authentification:</br>
```# ssh-copy-id root@10.1.1.1```
```
OUTPUT:
The authenticity of host '10.1.1.1 (10.1.1.1)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
```
OUTPUT:
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@10.1.1.1's password: << Enter "username" password and press ENTER
```
```
OUTPUT:
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@10.1.1.1'"
and check to make sure that only the key(s) you wanted were added.
```

Check if connection to srvC works:</br>
```# ssh root@10.1.1.1```
```
OUTPUT:
The authenticity of host '10.1.1.1 (10.1.1.1)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? << Type "yes" and press ENTER
```
If successful log out and log back in to server A to test transferring the backup file from server C to server A

</br>
</br>

**On server A // 10.0.0.1**

Test file transfer from server C to server A:</br>
```# rsync -acvzh -e "ssh -A root@2.2.2.2 ssh" --remove-source-files root@10.1.1.1:/var/lib/xtrabackup/backup/*.tar.gz /srvC_backup```


**Backup host Cronjob settings:****

Open crontab in editor:</br>
```# nano /etc/crontab```
```
00 12 * * * root find /srvC_backup/* -maxdepth 0 -mtime +6 -exec rm -rf {} +
30 02 * * * root rsync -acvzh --remove-source-files root@10.1.1.1:/var/lib/xtrabackup/backup/*.tar.gz /srvC_backup
```

Restart crond service:</br>
```# systemctl restart crond```

</br>
</br>

**Zabbix SQL database restore procedure**

Stop the MySQL service:</br>
```# systemctl stop mariadb```

Move backup files:</br>
```# cd /var/lib```
```# mv mysql mysqlcrashed```
```# mv xtrabackup/lastbackup mysql```

Start the MySQL service:</br>
```# systemctl start mariadb```

**Congrats!** You're done.