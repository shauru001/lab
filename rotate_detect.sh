#!/bin/bash

mysql --login-path=remote --host=ssh_mgm keys-db -e \
		"SELECT user_update FROM stage2_users WHERE user_update IS NOT NULL ORDER BY user_update ASC LIMIT 1;" \
		> result
exp_key=`tail -n1 result`
trigger_time=$(date +"%Y-%m-%d %H:%M:%S" -d "-60 days")
#trigger_time=$(date +"%Y-%m-%d %H:%M:%S" -d "-10 minutes")
echo "last update: $exp_key"
echo "trigeer: $trigger_time"

if [[ "${exp_key}" > "${trigger_time}" ]]; then
	echo "update in 1day,nothing to do."
else
	echo "one key updated order than 1day"
	mysql --login-path=remote --host=ssh_mgm keys-db -e \
			"SELECT user_account FROM stage2_users WHERE user_update IS NOT NULL ORDER BY user_update ASC LIMIT 1;" \
			> result_user
	exp_user=`tail -n1 result_user`
	echo "update user $exp_user key"
	sh rotate_key.sh $exp_user
fi
