#/bin/bash
sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=4 --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=13306  --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 cleanup
