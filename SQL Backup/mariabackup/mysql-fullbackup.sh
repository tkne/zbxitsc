#!/bin/bash

# SQL user info
MYSQLUSER="USERNAME"
MYSQLPASS="PASSWORD"

# MariaDB config & directory info
MYSQLCNF="/etc/my.cnf"
MYSQLDIR="/var/lib/mysql"

# Additional Zabbix files to backup
ETCZBX="/etc/zabbix/*"
USRLIBZBX="/usr/lib/zabbix/*"

# Backup directory settings
BASEDIR="/var/lib/mariabackup/backup"
BKPDIR="${BASEDIR}/lastbackup_$(date +%Y%m%d-%H%M)"
BKPDIRADD="${BASEDIR}/additional_backup_$(date +%Y%m%d-%H%M)"
BKPTEMPDIR="${BASEDIR}/tempbackup"
BKPETCZBX="${BKPDIRADD}/etc/zabbix"
BKPUSRLIBZBX="${BKPDIRADD}/usr/lib/zabbix"

# Memory used in backup stage 2
USEMEMORY="1GB"

# Create base directory
mkdir -p ${BASEDIR}

# Remove backup temporary directory
if [ -d "${BKPTEMPDIR}" ]; then
        rm -rf ${BKPTEMPDIR}
fi

# do backup - stage 1
mariabackup --innobackupex --defaults-file=${MYSQLCNF} --user=${MYSQLUSER} --no-timestamp --password=${MYSQLPASS} ${BKPTEMPDIR}

# do backup - stage 2 (prepare backup for restore)
mariabackup --innobackupex --apply-log --use-memory=${USEMEMORY} ${BKPTEMPDIR}

# Backup MySQL my.cnf file
cp -pf ${MYSQLCNF} ${BKPTEMPDIR}/my.cnf

# Change owner for backup temporary directory
chown -R mysql: ${BKPTEMPDIR}

# Move directory
mv ${BKPTEMPDIR} ${BKPDIR}

# Create backup directory for /etc/zabbix
mkdir -p ${BKPDIRADD}/etc/zabbix

# Backup /etc/zabbix directory
cp -prf ${ETCZBX} ${BKPETCZBX}

# Create backup directory for /usr/lib/zabbix
mkdir -p ${BKPDIRADD}/usr/lib/zabbix

# Backup /usr/lib/zabbix directory
cp -prf ${USRLIBZBX} ${BKPUSRLIBZBX}

# Create compressed archive file
tar -czvf ${BKPDIR}.tar.gz ${BKPDIR} ${BKPDIRADD}