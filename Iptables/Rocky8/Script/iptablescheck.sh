#!/bin/sh

systemctl is-active --quiet iptables.service >/dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="1"
fi

echo "$ST"
exit $EX