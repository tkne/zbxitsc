Graph Low Level Discovery for Zabbix
======

**Before** Disk IO status check setup for your Zabbix hosts

   * [Installation guide using installer shell script](#installation-guide-using-installer-shell-script)
   * [Installation guide **without** using installer shell script](#installation-guide-without-using-installer-shell-script)
</br>

**After** Disk IO status check setup for your Zabbix hosts

   * [Graph template setup and creation via Zabbix GUI](#graph-template-setup-and-creation-via-zabbix-gui)

</br>
</br>
</br>

## Installation guide using installer shell script

Run installer shell script:</br>
```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/Shell%20Script%20Installer/glld_install.sh | bash```


Open ```menu.inc.php``` in editor:</br>
```# nano /usr/share/zabbix/include/menu.inc.php```

Add following lines (marked with a +) at exactly the same location as shown below:
```diff
                                [
                                        'url' => 'maintenance.php',
                                        'label' => _('Maintenance')
                                ],
                                [
                                        'url' => 'actionconf.php',
                                        'label' => _('Actions')
                                ],
                                [
                                        'user_type' => USER_TYPE_SUPER_ADMIN,
                                        'url' => 'correlation.php',
                                        'label' => _('Event correlation')
                                ],
                                [
                                        'url' => 'discoveryconf.php',
                                        'label' => _('Discovery')
                                ],
                                [
                                        'url' => 'services.php',
                                        'label' => _('Services')
                                ],
+                               [
+                                       'url' => 'glld.php',
+                                       'label' => _('GLLD')
+                               ]
                        ]
                ],
                'admin' => [
```

Open ```glld.cli.php``` in editor:</br>
```# nano /usr/share/zabbix/glld/glld.cli.php```

Exchange **user** and **password** with proper write access credentials:
```php
#!/usr/bin/env php
<?php PHP_SAPI === 'cli' or die();
$auth=['user' => '', 'password' => '']; //fix this with valid user/password having Write access to Hosts
...
```

**Next**: proceed with the [**Disk IO status check setup for your Zabbix hosts**](https://github.com/tkne/zbxitsc/tree/master/Disk%20IO#disk-io-status-check-for-zabbix).

</br>
</br>
</br>
</br>

## Installation guide **without** using installer shell script

Create glld.php file:</br>
```# nano /usr/share/zabbix/glld.php```

Copy and paste the contents below:</br>
```php
<?php
//automate graphing of multiple LLD items on same graph
require_once dirname(__FILE__).'/include/config.inc.php';
require_once dirname(__FILE__).'/glld/glld.inc.php';
if (!empty($_GET['popup'])) itemPopup(); //popup for item proto select
$page['title'] = _('Graph multiple LLD items');
$page['file'] = 'glld.php';
$page['scripts'] = ['multiselect.js'];
require_once dirname(__FILE__).'/include/page_header.php';
//routing
switch (getRequest('action')) {
  case 'task.massdisable':  taskStatus(true);           break;
  case 'task.massenable':   taskStatus(false);          break;
  case 'task.massrun':      taskRun();                  break;
  case 'task.massclean':    taskClean();  taskList();   break;
  case 'task.massdelete':   taskDelete(); taskList();   break;
  default:
    if (isset($_REQUEST['form'])) taskEdit();
    else taskList();
}
require_once dirname(__FILE__).'/include/page_footer.php';
```

Create directory for glld:</br>
```# mkdir /usr/share/zabbix/glld```

Create glld.cli.php file:</br>
```# nano /usr/share/zabbix/glld/glld.cli.php```

Copy and paste the contents below:</br>
```php
#!/usr/bin/env php
<?php PHP_SAPI === 'cli' or die();
$auth=['user' => '', 'password' => '']; //fix this with valid user/password having Write access to Hosts
ini_set('display_errors', '1');

//auth
require_once dirname(__FILE__).'/../include/classes/core/Z.php';
Z::getInstance()->run(ZBase::EXEC_MODE_API);
$ssid=API::User()->login($auth);
if(!$ssid) die("Unable to login with provided credentials!\n");
API::getWrapper()->auth = $ssid;

require_once dirname(__FILE__).'/../include/db.inc.php';
require_once 'glld.inc.php';

//run all enabled tasks
foreach(taskLoad() as $task){
  if($task['status']) {echo "\nGraph '{$task['graph']['name']}' is disabled\n"; continue;}
  $hosts = getHosts($task['templateid']);
  echo "\nChecking graph '{$task['graph']['name']}' on ".count($hosts)." host(s)\n";
  foreach($hosts as $host) graphCheck($host, $task);
}
echo "\nDone.\n";
```

Exchange **user** and **password** with proper write access credentials:
```php
#!/usr/bin/env php
<?php PHP_SAPI === 'cli' or die();
$auth=['user' => '', 'password' => '']; //fix this with valid user/password having Write access to Hosts
...
```

Make glld.cli.php file executable:</br>
```# chmod +x /usr/share/zabbix/glld/glld.cli.php```

Create glld.inc.php file:</br>
```# nano /usr/share/zabbix/glld/glld.inc.php```

Copy and paste the contents from the link below:</br>
https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld/glld.inc.php

Create glld.js file:</br>
```# nano /usr/share/zabbix/glld/glld.js```

Copy and paste the contents from the link below:</br>
https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld/glld.js

Open ```menu.inc.php``` in editor:</br>
```# nano /usr/share/zabbix/include/menu.inc.php```

Add following lines (marked with a +) at exactly the same location as shown below:
```diff
                                [
                                        'url' => 'maintenance.php',
                                        'label' => _('Maintenance')
                                ],
                                [
                                        'url' => 'actionconf.php',
                                        'label' => _('Actions')
                                ],
                                [
                                        'user_type' => USER_TYPE_SUPER_ADMIN,
                                        'url' => 'correlation.php',
                                        'label' => _('Event correlation')
                                ],
                                [
                                        'url' => 'discoveryconf.php',
                                        'label' => _('Discovery')
                                ],
                                [
                                        'url' => 'services.php',
                                        'label' => _('Services')
                                ],
+                               [
+                                       'url' => 'glld.php',
+                                       'label' => _('GLLD')
+                               ]
                        ]
                ],
                'admin' => [
```

**Next**: proceed with the [**Disk IO status check setup for your Zabbix hosts**](https://github.com/tkne/zbxitsc/tree/master/Disk%20IO#disk-io-status-check-for-zabbix).

</br>
</br>
</br>
</br>

## Graph template setup and creation via Zabbix GUI

Please make sure you're done with the [**Disk IO status check setup for your Zabbix hosts**](https://github.com/tkne/zbxitsc/tree/master/Disk%20IO#disk-io-status-check-for-zabbix) before you proceed.
</br>

Within the Zabbix GUI, click on **Configuration** > **GLLD**:

![zbx_menu](https://i.imgur.com/tr2LmNv.png)

</br>

Next, click on **Create graph** in the upper right corner:

![glld_menu](https://imgur.com/YWkW30F.png)

</br>

We are going to create two graph templates now:

- **Disk iops Read/Write Bytes/s**, which contains the items for **Read Bytes/s** and **Write Bytes/s**
- **Disk iops Read/Write IOPS**, which contains the items for **Read IOPS/s** and **Write IOPS/s**

Use the screenshots below as a guide for your setup:

![graph_bps](https://imgur.com/WPGESDx.png)

![graph_IOPS](https://imgur.com/fDh9cMg.png)

</br>

Now that we have created the templates above, let's create some graphs by checking both template boxes and clicking on **Run** afterwards:

![glld_run](https://imgur.com/0Vtcpbu.png)

</br>

Agree by clicking on **OK**:

![glld_approve](https://imgur.com/qfM7ikk.png)

</br>

In my case, graphs for each host already exist and haven't changed, so GLLD is skipping those host. In your case new graphs will be created. If nothing happens, make sure that you've attached the [Template Disk IO](https://github.com/tkne/zbxitsc/blob/master/Disk%20IO/Template/Template%20Disk%20IO.xml) to your host/s. 

![glld_approve](https://imgur.com/5vH5HlU.png)

</br>

When done, you will get something pretty as this:

![glld_disk_graphs](https://imgur.com/XkwcDIR.png)

</br>
</br>
</br>
Credits: https://github.com/sepich