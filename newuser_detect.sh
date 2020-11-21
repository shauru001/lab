#!/bin/bash

# last create record
#mysql --login-path=remote --host=ssh_mgm keys-db << EOF
#	SELECT user_create FROM users ORDER BY user_id DESC LIMIT 1;
#EOF

mysql --login-path=remote --host=ssh_mgm keys-db -e \
		"SELECT user_create FROM users ORDER BY user_id DESC LIMIT 1;" \
		> result

last_create=`tail -n1 result`
#now_time=$(date +"%Y-%m-%d %H:%M:%S")
trigger_time=$(date +"%Y-%m-%d %H:%M:%S" -d "-10 minutes")
echo $last_create
echo $trigger_time

if [[ "${last_create}" > "${trigger_time}" ]]; then
	echo "new user created in 10mins"
	#sh /home/gecope/scripts/start_maintenance.sh
 else
	echo "no user created in 10mins"
fi
