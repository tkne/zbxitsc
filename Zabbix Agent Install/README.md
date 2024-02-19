# Zabbix Agent Installation on Linux

Collection of instructions for installing the Zabbix Agent on various Linux operating systems in Zabbix Server 4.X environments.

</br>

## CentOS 6
Install Zabbix release 4.4.1:
```bash
yum install http://repo.zabbix.com/zabbix/4.4/rhel/6/x86_64/zabbix-release-4.4-1.el6.noarch.rpm
```

</br>

Clean the local cache:
```bash
yum clean all
```

</br>

Install Zabbix Agent 4.4.10:
```bash
yum install zabbix-agent
```


</br>

## CentOS 7
Install Zabbix release 4.4.1:
```bash
yum install http://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
```

</br>

Clean the local cache:
```bash
yum clean all
```

</br>

Install Zabbix Agent 4.4.10:
```bash
yum install zabbix-agent
```

</br>

## Debian 6 (Squeeze)
Download Zabbix release 2.0:
```bash
wget http://repo.zabbix.com/zabbix/2.0/debian/pool/main/z/zabbix-release/zabbix-release_2.0-1squeeze_all.deb
```

</br>

Install `lsb-release` package:
```bash
apt-get install lsb-release
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_2.0-1squeeze_all.deb
```

</br>

Update from the new list:
```bash
apt-get update
```

</br>

Upgrade the installed packages on your system:
```bash
apt-get upgrade
```

</br>

Install Zabbix Agent 2.0.21:
```bash
apt-get install zabbix-agent
```
> [!IMPORTANT]
> Make sure the latest available version 2.0.21 has been installed.

</br>

## Debian 7 (Wheezy)
Download Zabbix release 3.4.1:
```bash
wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1%2Bwheezy_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_3.4-1+wheezy_all.deb
```

</br>

Update from the new list:
```bash
apt-get update
```

</br>

Install Zabbix Agent 3.4.15:
```bash
apt-get install zabbix-agent
```

</br>

## Debian 8 (Jessie)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bjessie_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+jessie_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.4.10:
```bash
apt install zabbix-agent
```

</br>

## Debian 9 (Stretch)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bstretch_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+stretch_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.4.10:
```bash
apt install zabbix-agent
```

</br>

## Debian 10 (Buster)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bbuster_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+buster_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.4.10:
```bash
apt install zabbix-agent
```

</br>

## Debian 11 (Bullseye)
Download Zabbix release 5.0.1:
```bash
wget http://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bbullseye_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_5.0-1+bullseye_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 5.0.15:
```bash
apt install zabbix-agent
```

</br>

## Debian 12 (Bookworm)
Download Zabbix release 6.0:
```bash
wget http://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_latest%2Bdebian12_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_latest+debian12_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 6.0.26:
```bash
apt install zabbix-agent
```

</br>

## Rocky Linux 8 (Green Obsidian)
Install Zabbix release 4.4.1:
```bash
dnf install https://repo.zabbix.com/zabbix/4.4/rhel/8/x86_64/zabbix-release-4.4-1.el8.noarch.rpm
```

</br>

Clean the local cache:
```bash
dnf clean all
```

</br>

Install Zabbix Agent 4.4.10:
```bash
dnf install zabbix-agent
```

</br>

## Rocky Linux 9 (Blue Onyx)
Install Zabbix release 5.0.3:
```bash
dnf install https://repo.zabbix.com/zabbix/5.0/rhel/9/x86_64/zabbix-release-5.0-3.el9.noarch.rpm
```

</br>

Clean the local cache:
```bash
dnf clean all
```

</br>

Install Zabbix Agent 5.0.41:
```bash
dnf install --disablerepo=* --enablerepo=zabbix zabbix-agent
```

</br>

## Ubuntu 14.04 (Trusty Tahr)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Btrusty_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+trusty_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.0.10:
```bash
apt install zabbix-agent
```

</br>

## Ubuntu 16.04 (Xenial Xerus)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bxenial_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+xenial_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.0.10:
```bash
apt install zabbix-agent
```

</br>

## Ubuntu 18.04 (Bionic Beaver)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bbionic_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+bionic_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.0.10:
```bash
apt install zabbix-agent
```

</br>

## Ubuntu 20.04 (Focal Fossa)
Download Zabbix release 4.4.1:
```bash
wget http://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1%2Bfocal_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.4-1+focal_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.0.10:
```bash
apt install zabbix-agent
```

</br>

## Ubuntu 22.04 (Jammy Jellyfish)
Download Zabbix release 4.0.4:
```bash
wget http://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-4%2Bubuntu22.04_all.deb
```

</br>

Install Zabbix release package:
```bash
dpkg -i zabbix-release_4.0-4+ubuntu22.04_all.deb
```

</br>

Update from the new list:
```bash
apt update
```

</br>

Install Zabbix Agent 4.0.50:
```bash
apt install zabbix-agent
```