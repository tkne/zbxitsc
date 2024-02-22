# Zabbix server SQL database backup

> This guide explains the process of performing a comprehensive backup of a MariaDB SQL database environment running on CentOS or Rocky Linux systems. The main focus is on efficiently backing up the Zabbix 4.4.X server database (although it should be compatible with any version) and ensuring swift recovery in case of a disaster.
</br>

Please note that the backup procedure may vary depending on the specific version of MariaDB you are using, as [mentioned in the cited documentation](https://mariadb.com/kb/en/percona-xtrabackup-overview/).

> [!IMPORTANT]
> In **MariaDB 10.1** and later, `Mariabackup` is the recommended backup method to use instead of Percona XtraBackup.

> [!WARNING]
> In **MariaDB 10.3**, `Percona XtraBackup` is **not supported**.</br>
> See [Percona XtraBackup Overview: Compatibility with MariaDB](https://mariadb.com/kb/en/percona-xtrabackup-overview/#compatibility-with-mariadb) for more information.

> [!WARNING]
> In **MariaDB 10.2** and **MariaDB 10.1**, `Percona XtraBackup` is **only partially supported**. See [Percona XtraBackup Overview: Compatibility with MariaDB](https://mariadb.com/kb/en/percona-xtrabackup-overview/#compatibility-with-mariadb) for more information.
</br>

## Step-by-Step Guides
- [Backup and Restore procedure using Percona XtraBackup 2.4](https://github.com/tkne/zbxitsc/tree/master/SQL%20Backup/xtrabackup)
- [Backup and Restore procedure using Mariabackup](https://github.com/tkne/zbxitsc/tree/master/SQL%20Backup/mariabackup/)

#### Addendum
- [LAN IP to LAN IP access via public IP hop](https://github.com/tkne/zbxitsc/tree/master/SQL%20Backup/addendum/)