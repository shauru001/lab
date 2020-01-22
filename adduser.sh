#!/bin/bash

group_optsr=("Cola" "Jill" "Max")
group_optjr=("Jacky" "domo")
group_devsr=("ling" "wang")
greoup_devjr=("fang" "sam")
group_tool=("ansible" "jenkins")

printf "\E[0;36;40m"
echo -n "Choose Group: (1)OPT-Senior (2)OPT-Junior (3)DEV-Senior (4)DEV-Junior (5)CICD-TOOL (Enter Number):"
printf "\E[0m"
read group_id
if [ $group_id = 1 ]; then
    echo ${group_optsr[@]}
    echo -n "Input "0" for all users or keyin one username: "
    read username
    if [ $username = 0 ]; then
        echo "add all users"
    else
        echo "add $username"
elif [ $group_id = 2 ]; then
    echo ${group_optjr[@]}
    echo -n "Input "0" for all users or keyin one username: "
    if [ $username = 0 ]; then
        echo "add all users"
    else
        echo "add $username"
else
    printf "\E[0;31;40m"
    echo "not opt user~"
    printf "\E[0m"
fi
