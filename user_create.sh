#!/bin/bash -x

site=$1
uName=$2
gName=$3
today=`date +%F`
keyDate=`cat user_list.csv | grep $uName | cut -d, -f3`

ansible-playbook playbook/user_create.yml --inventory=inventories/${site} --extra-vars "user_account=${uName} user_group=${gName} key_comment=${today}"

if [ -z $keyDate ]; then
    cp user_list.csv user_list.csv.$today
    echo ${uName},${gName},${today} >> user_list.csv
else
    cp user_list.csv user_list.csv.$today
    egrep -lRZ "grep $uName user_list.csv" . \
    | xargs -0 -l sed -i "s#$keyDate#$today#g" user_list.csv
fi


