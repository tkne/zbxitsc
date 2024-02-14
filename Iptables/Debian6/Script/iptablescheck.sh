#!/bin/sh

grep filter /proc/net/ip_tables_names  > /dev/null 2>&1
RC=$?
if [ $RC -eq 0 ]; then
        ST="1"
        EX="0"
else
        ST="0"
        EX="2"
fi

echo "$ST"
exit $EX