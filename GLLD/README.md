Graph Low Level Discovery for Zabbix
======

Before Disk IO status check setup for your Zabbix hosts

   * [Installation guide using installer shell script](#installation-guide-using-installer-shell-script)
   * [Installation guide **without** using installer shell script](#installation-guide-without-using-installer-shell-script)

</br>
</br>
</br>
</br>

## Installation guide using installer shell script

Run installer shell script:</br>
```# wget -O - https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/Shell%20Script%20Installers/glld_install.sh | bash```


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

When done, proceed with the [**Disk IO status check setup for your Zabbix hosts**](https://github.com/tkne/zbxitsc/tree/master/Disk%20IO).

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

When done, proceed with the [**Disk IO status check setup for your Zabbix hosts**](https://github.com/tkne/zbxitsc/tree/master/Disk%20IO).