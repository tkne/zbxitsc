# Disk IO status check for Zabbix agent on CentOS 7

> This guide assumes that the Zabbix agent user config path is set to `/etc/zabbix/zabbix_agentd.d/` or `/etc/zabbix/zabbix_agentd.d/*.conf`.

Make sure to install GLLD on the Zabbix server first before you proceed:</br>
https://github.com/tkne/zbxitsc/tree/master/GLLD#graph-low-level-discovery-for-zabbix

</br>

## Installation via shell script
```bash
wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/Disk%20IO/CentOS7/Shell%20Script/diskio_install.sh | bash
```

</br>

## Installation guide using step by step instructions
Create a new file called `iostat.conf` within the `/etc/zabbix/zabbix_agentd.d/` directory:
```bash
nano /etc/zabbix/zabbix_agentd.d/iostat.conf
```

</br>

Insert the contents below and save the file:
```bash
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

</br>

Create a new file called `lld-disks.py` within the `/usr/local/bin/` directory:
```bash
nano /usr/local/bin/lld-disks.py
```

</br>

Insert the contents below and save the file:
> [!IMPORTANT]
> Please check your Python path with your installation and update the location if necessary.</br>
```py
#!/bin/python
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

</br>

Make the file executable:
```bash
chmod +x /usr/local/bin/lld-disks.py
```

</br>

Restart the Zabbix agent service:
```bash
systemctl restart zabbix-agent
```

</br>

When done, import the [**Template Disk IO**](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Template/Template%20Disk%20IO.xml).
Remember, the discovery update interval for this template is set to a default of one hour (1h). You can set it to something lower (i.e. 1m) while you are setting up to speed things up.

</br>

### Next
Proceed with the [**Graph template setup and creation via Zabbix GUI**](https://github.com/tkne/zbxitsc/tree/master/GLLD#graph-template-setup-and-creation-via-zabbix-gui).

</br>

Credits: https://github.com/grundic