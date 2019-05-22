#!/bin/bash
echo "restart mysql"
echo "123" | sudo -S ssh -p 5022 ljh@127.0.0.1 "echo '123'|sudo -S service mysql restart > /dev/null 2>&1;exit "
sleep 3
