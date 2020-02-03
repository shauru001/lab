#!/bin/bash

tmp_dir="playbook/user/.pubkey"
user_account=$1

# create user & key
sudo useradd $user_account -s /bin/bash
ssh-keygen -b 2048 -t rsa -f $tmp_dir/$user_account -q -N ""


user_pubkey=`cat $tmp_dir/$user_account.pub`
user_prikey=`cat $tmp_dir/$user_account`

# save key to database
mysql --login-path=remote --host=ssh_mgm keys-db << EOF
	INSERT INTO users (user_account, user_pubkey, user_prikey, user_create) \
	VALUES ("$user_account", "$user_pubkey", "$user_prikey", NOW());
EOF
