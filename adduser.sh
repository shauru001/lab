#!/bin/bash

#export current_dir="$(pwd)"

group_optsr=("optsr1" "optsr2")
group_optjr=("optjr1" "optjr2")
group_devsr=("devsr1" "devsr2")
greoup_devjr=("devjr1" "devjr2")
group_tool=("ansible" "jenkins")

printf "\E[0;36;40m"
echo -n "Choose Group: (1)OPT-Senior (2)OPT-Junior (3)DEV-Senior (4)DEV-Junior (5)CICD-TOOL (Enter Number):"
printf "\E[0m"
read group_id
if [ $group_id = 1 ]; then
	echo "user list: "${group_optsr[@]}
    echo -n "Input 0 for all users or keyin one username:"
	read optsr_user
    optsr_id=$(echo $optsr_user | tr [A-Z] [a-z])
	    if [ $optsr_user = 0 ]; then
            echo "add all optsr users"
            ansible-playbook ./playbook/user/create_optsr_*.yml
        else
            echo "add $optsr_user"
            ansible-playbook ./playbook/user/create_optsr_$optsr_id.yml
        fi
elif [ $group_id = 2 ]; then
	echo "user list: "${group_optjr[@]}
    echo -n "Input 0 for all users or keyin one username:"
	read optjr_user
    optjr_id=$(echo $optjr_user | tr [A-Z] [a-z])
	    if [ $optjr_user = 0 ]; then
            echo "add all optjr users"
            ansible-playbook ./playbook/user/create_optjr_*.yml
        else
            echo "add $optjr_user"
            ansible-playbook ./playbook/user/create_optsr_$optjr_id.yml
        fi
else
	printf "\E[0;31;40m"
	echo "not opt user~"
	printf "\E[0m"
fi
