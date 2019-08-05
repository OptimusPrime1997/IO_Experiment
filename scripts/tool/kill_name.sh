#!/bin/bash
NAME=$1
sudo ps -ef |grep $NAME | grep -v grep | awk '{print $2}' |xargs kill -9

