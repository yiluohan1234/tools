#!/bin/bash
#######################################################################
	#'''	
	#> File Name: vpn.sh
	#> Author: cyf
	#> Mail: XXX@qq.com
	#> Created Time: 2016年08月26日 星期五 21时49分42秒
	#'''	
#######################################################################
auto_login_ssh()
{
	expect -c "set timeout -1;
	spawn -noecho ssh -o StrictHostKeyChecking=no $2 ${@:3};
	expect *assword:*;
	send -- $1\r;
	interact";
}
auto_smart_ssh()
{
	expect -c "set timeout -1;
	spawn ssh -o StrictHostKeyChecking=no $2 ${@:3};
	expect {
	*assword:* {send -- $1\r;
	expect {
	*denied* {exit 2;}
	eof
}}
	eof {exit 1;}
}"
return $?
}
auto_scp()
{
	expect -c "set timeout -1;
	spawn scp -o StrictHostKeyChecking=no ${@:2}
	expect {
	*assword:* {send -- $1\r;
	expect {
	*denied* {exit 1;}
	eof
}}
eof {exit 1;}
}
"
return $?
}
auto_ssh_copy_id() {
expect -c "set timeout -1;
spawn ssh-copy-id $2;
expect {
*(yes/no)* {send -- yes\r;exp_continue;}
*assword:* {send -- $1\r;exp_continue;}
eof {exit 0;}
}";
}
auto_ssh_copy_id $1 $2
