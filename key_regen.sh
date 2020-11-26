#!/bin/bash -x

site=$1
u_name=$2
age=$3
#g_name=$3
msg=`date +%F`
gen_time=`cat user_list.csv | grep $u_name | cut -d, -f3`

ansible-playbook playbook/key_create.yml --inventory=inventories/${site} --extra-vars "user_account=${u_name} key_comment=${msg} exp_date=${age}"

