#!/bin/sh
DIR="/opt/web/backup"
cd $DIR 
svn export https://dx.dev.lenovodata.com/svn/web/ld_bee ./ld_bee
TARNAME=`date "+%Y.%m.%d.%H"`".tar.gz"
echo $TARNAME
tar -zcf  $TARNAME "./ld_bee"
rm -rf "/opt/web/backup/ld_bee"

