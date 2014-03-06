#!/bin/sh
pid=`ss -l4np | grep 12315 | awk -F\, '{print $2}'`
echo =$pid=
if [ -z $pid ]
then
    echo "not running"
    ssh -qfTnN -D *:12315 -p 443 hyena_@123.150.177.30
    echo "start ok"
else
    echo "already running"
fi

