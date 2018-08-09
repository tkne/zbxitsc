#!/bin/sh
# This script will install Graph Low Level Discovery for Zabbix.

# Download glld.php file
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld.php -O /usr/share/zabbix/glld.php

# Create directory for glld
mkdir /usr/share/zabbix/glld

# Download glld.cli.php file
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld/glld.cli.php -O /usr/share/zabbix/glld/glld.cli.php

# Download glld.inc.php file
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld/glld.inc.php -O /usr/share/zabbix/glld/glld.inc.php

# Download glld.js file
wget https://raw.githubusercontent.com/tkne/zbxitsc/master/GLLD/glld/glld.js -O /usr/share/zabbix/glld/glld.js

# Make glld.cli.php file executable
chmod +x /usr/share/zabbix/glld/glld.cli.php

# Success message
echo "Graph Low Level Discovery for Zabbix successfully installed!"