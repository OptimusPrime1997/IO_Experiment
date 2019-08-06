#!/bin/bash

### BEGIN INIT INFO
# Provides:          ljh
# Required-Start:    $remote_fs $syslog $network $named
# Required-Stop:     $remote_fs $syslog $network 
# Should-Start:      $network $portmap
# Should-Stop:       $network $portmap
# X-Start-Before:    nis
# X-Stop-After:      nis
# Default-Start:     1 2 3 5 6
# Default-Stop:      0 1 2 4 6
# X-Interactive:     false
# Short-Description: ss auto start script
# Description:       /dev/sdb format，fetch data，start mysql and sshd auto script,
#                    This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO
DISK=$1
ps -ef |grep mysql |grep  -v grep &> /dev/null
if [ $? -eq 0 ];then
	echo "mysql service is running"
else
	echo y | mkfs.ext4 /dev/$DISK
	mount /dev/$DISK /opt
	sudo cp -r /home/ljh/stores/opt/* /opt/
fi
echo "execute /etc/init.d/sdb-init.sh" >> /var/log/init.log
chown mysql:mysql -R /opt/*
service mysql start
service sshd start
