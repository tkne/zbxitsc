# Procedure using Percona XtraBackup 2.4
This is a step-by-step guide for backing up the Zabbix server MariaDB database using Percona XtraBackup 2.4. The target files and directories are as follows:
```bash
# MariadDB configuration
/etc/my.cnf

# Zabbix configurations
/etc/zabbix

# Zabbix user scripts
/usr/lib/zabbix

# MariaDB data files 
/var/lib/mysql
```

If you wish to proceed directly to the database restore procedure, [please click here](#restore).</br>


## Backup
First, visit the [Percona Downloads website](https://www.percona.com/downloads). Scroll down to `Percona XtraBackup` and click on `Percona XtraBackup 2.4`. From there, select the desired version and choose your platform. Once you have completed these steps, please copy the download link from the top option.
</br>

### 1. Backup Settings on Zabbix Server
Download Percona XtraBackup 2.4 to server:
```bash
wget insert-percona-xtrabackup-download-link.rpm
```
</br>

Install the Percona XtraBackup 2.4 package:</br>
```bash
yum -y install percona-xtrabackup-24-*.rpm
```
</br>

Create backup folders:</br>
```bash
mkdir -p /var/lib/xtrabackup/backup
```
</br>

Download backup shell script:</br>
```bash
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/SQL%20Backup/xtrabackup/mysql-fullbackup.sh -O /var/lib/xtrabackup/mysql-fullbackup.sh
```
> [!IMPORTANT]
> Please update the information below:
> ```bash
> # SQL user info
> MYSQLUSER="USERNAME"
> MYSQLPASS="PASSWORD"
> ```
> Additionally, please verify if there are any other settings that require updating.

</br>

Make backup shell script executable:</br>
```bash
chmod +x /var/lib/xtrabackup/mysql-fullbackup.sh
```
</br>

Test the backup shell script:</br>
```bash
sh /var/lib/xtrabackup/mysql-fullbackup.sh
```
</br>

Check your results:</br>
```bash
ls -la /var/lib/xtrabackup/backup/
```
It should contain files and folders similar to the following:
```bash
additional_backup_20240101-0000
lastbackup_20240101-0000
lastbackup_20240101-0000.tar.gz
```
</br>

### Troubleshooting
If your backup fails due to encountering the `Too many open files` issue described below, [please follow this link](https://www.percona.com/blog/using-percona-xtrabackup-mysql-instance-large-number-tables/) to learn how to resolve this problem.
```
InnoDB: Operating system error number 24 in a file operation.
InnoDB: Error number 24 means 'Too many open files' 
```

</br>

### 2. Cronjob Settings on Zabbix Server
To automate things, we will utilize Cronjobs with the following schedule for following tasks:
- Remove backups older than one day daily at 08:00 a.m.
- Create a database backup daily at 01:00 a.m.

</br>

Open `/etc/crontab/` in editor:
```bash
nano /etc/crontab
```
Add the following and save:
```bash
00 08 * * * root find /var/lib/xtrabackup/backup/* -maxdepth 0 -exec rm -rf {} +
00 01 * * * root /var/lib/xtrabackup/mysql-fullbackup.sh >/var/lib/xtrabackup/lastrun.log 2>&1
```
</br>

Restart the crond service:
```bash
systemctl restart crond
```
</br>

### 3. Cronjob Settings on a Backup Server
To move the backup file off-site to a different server and ensure that only recent backups are kept, we will employ Cronjobs with the following schedule for the following tasks::
- Remove files in the designated backup folder that are older than six days daily at 08:00 a.m.
- Transfer backup files from the Zabbix server to the backup server using rsync. Once the transfer is complete, remove the source files from the server daily at 02:00 a.m.

</br>

Open `/etc/crontab/` in editor:
```bash
nano /etc/crontab
```
Add the following and save:
```bash
00 08 * * * root find /path/to/your/backup/folder/* -maxdepth 0 -mtime +6 -exec rm -rf {} +
00 02 * * * root rsync -acvzh --remove-source-files root@<Your-Zabbix-Server-IP-Address>:/var/lib/xtrabackup/backup/*.tar.gz /path/to/your/backup/folder
```

Restart crond service:
```bash
systemctl restart crond
```
</br>

> [!TIP]
> Check the addendum [LAN IP to LAN IP access via public IP hop](https://raw.githubusercontent.com/tkne/zbxitsc/master/SQL%20Backup/addendum/) guide if in need for a similar setup.

</br>
</br>

# Restore
Before proceeding with the restore procedure, please upload your `lastbackup_*.tar.gz` backup file to your Zabbix server, which you are about to restore, and place it inside the `/var/lib/xtrabackup` directory.

</br>

Stop the Zabbix server service:
```bash
systemctl stop zabbix-server
```
</br>

Stop the MariaDB service:
```bash
systemctl stop mariadb
```
</br>

Change to the `/var/lib` directory:
```bash
cd /var/lib
```
</br>

Backup old mysql folder if you need to:
```bash
mv mysql mysql_old
```
</br>

Change to the `/var/lib/xtrabackup` directory:
```bash
cd /var/lib/xtrabackup
```
</br>

Extract files from the backup file:
```bash
tar -xzf lastbackup_*.tar.gz
```
</br>

Restore the `/var/lib/mysql` folder from your backup:
```bash
mv /var/lib/xtrabackup/var/lib/xtrabackup/backup/lastbackup_* /var/lib/mysql
```
</br>

Set permissions on the `/var/lib/mysql` folder:
```bash
chown -R mysql:mysql /var/lib/mysql
```
```bash
chmod 755 /var/lib/mysql
```
</br>

Start the MariaDB service:
```bash
systemctl start mariadb
```
</br>

Start the Zabbix server service:
```bash
systemctl start zabbix-server
```
</br>

Congratulations!</br>
You should now be able to access your Zabbix dashboard in your browser once again.