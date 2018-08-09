Disk IO status check for Zabbix
======

</br>
</br>

**!!! Make sure to install GLLD on the Zabbix server first before you proceed !!!** 

</br>
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
</br>

## On CentOS 6.x (with installer shell script)

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

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Shell%20Script%20Installers/diskio_install_centos6x.sh | bash```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.

</br>
</br>

## On CentOS 7.x (with installer shell script)

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

```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Shell%20Script%20Installers/diskio_install_centos7x.sh```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.

</br>
</br>

## On Debian 8.x (with installer shell script)

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

```$ wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/Shell%20Script%20Installers/diskio_install_debian8x.sh | bash```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.

</br>
</br>
</br>
</br>

## On CentOS 6.x (manual install)

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

Create a new file called ```iostat.conf```:
```# nano /etc/zabbix/zabbix_agentd.conf.d/iostat.conf```

Insert the contents below and save:
```
### DISK I/O###
UserParameter=custom.vfs.discover_disks,/usr/local/bin/lld-disks.py

UserParameter=custom.vfs.dev.read.ops[*],awk '{print $$1}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.merged[*],awk '{print $$2}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.sectors[*],awk '{print $$3}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.ms[*],awk '{print $$4}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ops[*],awk '{print $$5}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.merged[*],awk '{print $$6}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.sectors[*],awk '{print $$7}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ms[*],awk '{print $$8}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.active[*],awk '{print $$9}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.ms[*],awk '{print $$10}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.weight.io.ms[*],awk '{print $$11}' /sys/class/block/$1/stat
### DISK I/O###
```

Create a new file called ```lld-disks.py``` in ```/usr/local/bin/```:
```# nano /usr/local/bin/lld-disks.py```

Insert the contents below and save:
```python
#!/usr/bin/python
import os
import json

if __name__ == "__main__":
    # Iterate over all block devices, but ignore them if they are in the
    # skippable set
    skippable = ("sr", "loop", "ram")
    devices = (device for device in os.listdir("/sys/class/block")
               if not any(ignore in device for ignore in skippable))
    data = [{"{#DEVICENAME}": device} for device in devices]
    print(json.dumps({"data": data}, indent=4))
```

Make the file executable:
```# chmod +x /usr/local/bin/lld-disks.py```

Restart Zabbix agent service:
```# service zabbix-agent restart```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.

</br>
</br>

## On CentOS 7.x (manual install)

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

Create a new file called ```iostat.conf```:
```# nano /etc/zabbix/zabbix_agentd.conf.d/iostat.conf```

Insert the contents below and save:
```
### DISK I/O###
UserParameter=custom.vfs.discover_disks,/usr/local/bin/lld-disks.py

UserParameter=custom.vfs.dev.read.ops[*],awk '{print $$1}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.merged[*],awk '{print $$2}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.sectors[*],awk '{print $$3}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.ms[*],awk '{print $$4}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ops[*],awk '{print $$5}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.merged[*],awk '{print $$6}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.sectors[*],awk '{print $$7}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ms[*],awk '{print $$8}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.active[*],awk '{print $$9}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.ms[*],awk '{print $$10}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.weight.io.ms[*],awk '{print $$11}' /sys/class/block/$1/stat
### DISK I/O###
```

Create a new file called ```lld-disks.py``` in ```/usr/local/bin/```:
```# nano /usr/local/bin/lld-disks.py```

Insert the contents below and save:
```python
#!/usr/bin/python
import os
import json

if __name__ == "__main__":
    # Iterate over all block devices, but ignore them if they are in the
    # skippable set
    skippable = ("sr", "loop", "ram")
    devices = (device for device in os.listdir("/sys/class/block")
               if not any(ignore in device for ignore in skippable))
    data = [{"{#DEVICENAME}": device} for device in devices]
    print(json.dumps({"data": data}, indent=4))
```

Make the file executable:
```# chmod +x /usr/local/bin/lld-disks.py```

Restart Zabbix agent service:
```# systemctl restart zabbix-agent```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.

</br>
</br>

## On Debian 8.x (manual install)

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

Create a new file called ```iostat.conf```:
```$ nano /usr/local/etc/zabbix_agentd.conf.d/iostat.conf```

Insert the contents below and save:
```
### DISK I/O###
UserParameter=custom.vfs.discover_disks,/usr/local/bin/lld-disks.py

UserParameter=custom.vfs.dev.read.ops[*],awk '{print $$1}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.merged[*],awk '{print $$2}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.sectors[*],awk '{print $$3}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.ms[*],awk '{print $$4}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ops[*],awk '{print $$5}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.merged[*],awk '{print $$6}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.sectors[*],awk '{print $$7}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ms[*],awk '{print $$8}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.active[*],awk '{print $$9}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.ms[*],awk '{print $$10}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.weight.io.ms[*],awk '{print $$11}' /sys/class/block/$1/stat
### DISK I/O###
```

Create a new file called ```lld-disks.py``` in ```/usr/local/bin/```:
```$ nano /usr/local/bin/lld-disks.py```

Insert the contents below and save:
```python
#!/usr/bin/python
import os
import json

if __name__ == "__main__":
    # Iterate over all block devices, but ignore them if they are in the
    # skippable set
    skippable = ("sr", "loop", "ram")
    devices = (device for device in os.listdir("/sys/class/block")
               if not any(ignore in device for ignore in skippable))
    data = [{"{#DEVICENAME}": device} for device in devices]
    print(json.dumps({"data": data}, indent=4))
```

Make the file executable:
```$ chmod +x /usr/local/bin/lld-disks.py```

Restart Zabbix agent service:
```$ service zabbix-agent restart```

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Templates/Template%20Disk%20IO.xml) and your're good to go.