# LAN IP to LAN IP access via public IP hop

> This is a step-by-step guide that explains how to download a database backup file from our Zabbix Server and transfer it to our Backup Server using a public IP server hop connection. To ensure success, the hop server needs to be on the same LAN as the Zabbix Server.

In this example, we will be using the following servers and IP addresses:
```
Backup Server (10.0.0.1)
Hop Server (1.2.3.4 / 192.168.0.1) 
Zabbix Server (192.168.0.2)
```
</br>

## Usage
### 1. Settings on Backup Server (10.0.0.1)

Create an SSH key pair:
```bash
ssh-keygen
```
</br>

Confirm by pressing the ENTER key:
```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa):
```
</br>

Confirm by pressing the ENTER key for `no passphrase`:
```bash
Enter passphrase (empty for no passphrase):
```
</br>

Connect to the **Hop Server (1.2.3.4 / 192.168.0.1)** for authentification:
```bash
ssh-copy-id root@1.2.3.4
```
</br>

Confirm by typing `yes` and press the ENTER key:
```bash
The authenticity of host '1.2.3.4 (1.2.3.4)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)?
```
</br>

Type in your `password` and press the ENTER key:
```bash
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@1.2.3.4's password:
```
```bash
Number of key(s) added: 1

Now try logging into the machine, with: "ssh 'root@1.2.3.4'" and check to make sure that only the key(s) you wanted were added.
```
</br>

Please check if the connection to the **Hop Server (1.2.3.4 / 192.168.0.1)** is working:
```bash
ssh root@1.2.3.4
```
</br>

Confirm by typing `yes` and press the ENTER key:
```bash
The authenticity of host '1.2.3.4 (1.2.3.4)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)?
```
If the connection is successfully established, repeat the same procedure on the **Hop Server (1.2.3.4 / 192.168.0.1)** to connect to the **Zabbix Server (192.168.0.2)**.

</br>

### 2. Settings on Hop Server (1.2.3.4 / 192.168.0.1)

Create an SSH key pair:
```bash
ssh-keygen
```
</br>

Confirm by pressing the ENTER key:
```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa):
```
</br>

Confirm by pressing the ENTER key for `no passphrase`:
```bash
OUTPUT:
Enter passphrase (empty for no passphrase):
```
</br>

Connect to the **Zabbix Server (192.168.0.2)** for authentification:
```bash
ssh-copy-id root@192.168.0.2
```
</br>

Confirm by typing `yes` and press the ENTER key:
```bash
The authenticity of host '192.168.0.2 (192.168.0.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)?
```
</br>

Type in your `password` and press the ENTER key:
```bash
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.2's password:
```
```bash
Number of key(s) added: 1

Now try logging into the machine, with: "ssh 'root@192.168.0.2'" and check to make sure that only the key(s) you wanted were added.
```
</br>

Please check if the connection to the **Zabbix Server (192.168.0.2)** is working:
```bash
ssh root@192.168.0.2
```
</br>

Confirm by typing `yes` and press ENTER:
```bash
The authenticity of host '192.168.0.2 (192.168.0.2)' can't be established.
ECDSA key fingerprint is xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)?
```
If successful, log out and then log back in to the **Backup Server (10.0.0.1)** to test the transfer of the backup file from the **Zabbix Server (192.168.0.2)** to the **Backup Server (10.0.0.1)**.

</br>

### 3. File transfer test

Perform a test file transfer from the **Zabbix Server (192.168.0.2)** to the  **Backup Server (10.0.0.1)**:
```bash
rsync -acvzh -e "ssh -A root@1.2.3.4 ssh" --remove-source-files root@192.168.0.2:/var/lib/xtrabackup/backup/*.tar.gz /zabbix-db-backup
```
</br>

That's about it. Congratulations!