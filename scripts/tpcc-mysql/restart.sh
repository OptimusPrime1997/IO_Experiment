#!/usr/bin/expect
set passwd "123"
set time 5              
#set IP "192.168.122.77"
spawn ssh -p5022 ljh@192.168.122.77

expect {

"*yes/no" { send "yes\r"; exp_continue }

"*password:" { send "$passwd\r" }

}

expect "*#"                      

send "echo '123'|sudo -S service mysql restart > /dev/null 2>&1;exit;\r" 

expect "*#"    

#send "exit\r"

#interact

#expect eof
