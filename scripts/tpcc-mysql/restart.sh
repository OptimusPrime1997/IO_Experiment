#!/bin/bash

passwd='123'

/usr/bin/expect <<-EOF

set time 5              

spawn ssh -p5022 ljh@127.0.0.1

expect {

"*yes/no" { send "yes\r"; exp_continue }

"*password:" { send "$passwd\r" }

}

expect "*#"                      

send "echo '123'|sudo -S service mysql restart > /dev/null 2>&1;\r" 

expect "*#"    

send "exit\r"

interact

expect eof

EOF
