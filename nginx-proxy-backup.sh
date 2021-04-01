#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
SOURCE=/opt/nginx-proxy
BACKUP_LOCATION=/root/nginx-proxy
mkdir -p $BACKUP_LOCATION
STAMP=`date +"%Y-%m-%d_%H%M%S"`
cd $SOURCE && tar cpvzf $BACKUP_LOCATION/data-$STAMP.tgz data/ | mail -s "nginx-proxy data backup" admin@coredev.it

