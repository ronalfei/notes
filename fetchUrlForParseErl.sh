#!/bin/sh
echo -e "\033[32mstart......\033[0m"
if [ -z "$1" ]; then
    echo "no type input"
	exit
fi
if [ -z "$2" ]; then
    echo "no pagenum input"
	exit
fi
type=$1
pagenum=$2
filename=$type.data
resultfile=$type.$pagenum.result
curl -o $filename "$url"
