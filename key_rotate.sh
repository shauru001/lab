#!/bin/bash
#stamp2date (){
#    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
#}
mailSubject="[AWS] KEY Update Inform"
mailContent="FYI attachment"
sender="SRE Team"
attachFile=""
mapfile -t keyArray < user_list.csv

#time caculator
date2stamp () {
    date --utc --date "$1" +%s
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=-1; else abs=1; fi
    echo $((diffSec/sec*abs))
}

#handle key expiration
today=`date +%F`
expDate=`date +%F -d "-90 days"`
site=local-test

while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
do
    uName=${rec_column1[@]}
    keyDate=${rec_column3[@]}
    uMail=${rec_column4[@]}
    age=`dateDiff -d $keyDate $today`
    echo key_ages: $age
    if [[ $age > $expDate || $age = 0 ]]; then
        echo no expired keys
    else
        echo there are expired keys
        echo $uName $uMail
        cp user_list.csv user_list.$today
        ansible-playbook playbook/key_create.yml --inventory=inventories/${site} --extra-vars "user_account=${uName} key_comment=${today} exp_date=${keyDate}"
        egrep -lRZ "grep $uName user_list.csv" . \
        | xargs -0 -l sed -i "s#$keyDate#$today#g" user_list.csv
        echo $mailContent | mail -s $mailSubject -a ~/.fetch${uName}/lab-mgmt-2/home/${uName}/.ssh/id_rsa $uMail
    fi
done < user_list.csv
