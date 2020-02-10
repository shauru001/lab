#!/bin/bash

user_account=$1
user_group=$2
tmp_dir="/usr/local/.remote/auth"
rotate_tamplate="playbook/user/rotate_key.yaml"
home="/home/$user_account"
logfile="/home/ubuntu/log/sshkey/rotate_key-`date +%Y%m%d`.log"
exec 1>$logfile 2>&1

# stage2 rotation key
ssh-keygen -b 2048 -t rsa -f $tmp_dir/$user_account -q -N ""
sudo mv $tmp_dir/$user_account $home/.ssh/id_rsa
	#-- private key for login stage2: $home/.ssh/id_rsa
sudo chown $user_account: $home/.ssh/ -R

# backup table: stage2_users
mysqldump  --login-path=remote --host=ssh_mgm keys-db stage2_users > \
		/home/ubuntu/backup/database/table:stage2_users_`date +"%Y%m%d-%H%M%S"`.sql

# update key time to database
mysql --login-path=remote --host=ssh_mgm keys-db << EOF
	UPDATE stage2_users SET user_update = (NOW()) WHERE user_account="$user_account";
EOF

# deploy rotation key to ssh_mgm
cp $rotate_tamplate playbook/user/rotate_key_${user_account}.yaml
sed -i s/user_account/${user_account}/g playbook/user/rotate_key_${user_account}.yaml

ansible-playbook playbook/user/rotate_key_${user_account}.yaml
