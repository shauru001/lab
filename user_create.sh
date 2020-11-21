#!/bin/bash

site=$1
u_name=$2
g_name=$3
msg=`date +%s`

ansible-playbook playbook/user_create.yml --inventory=inventories/${site} --extra-vars "user_account=${u_name} user_group=${g_name} key_comment=${msg}"

echo ${u_name},${g_name},${msg} >> user_list.csv


