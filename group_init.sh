#!/bin/bash -e

site=$1
#g_name=$2 #sudo config tamplate: op_group, rd_group, ci_group

ansible-playbook playbook/group_init.yml --inventory=inventories/${site} -v
#ansible-playbook playbook/group_init.yml --inventory=inventories/${site} -v --extra-vars "user_group=${g_name}"
#ansible-playbook playbook/group_init.yml --inventory=\"inventories/${site}\" -v --extra-vars "user_group=${g_name}"


