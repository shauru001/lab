#!/bin/bash

user_account=$1
user_group=$2
tmp_dir="/usr/local/.remote/auth"
create_tamplate="playbook/user/create_user.yaml"
home="/home/$user_account"
logfile="/home/ubuntu/log/sshkey/create_user-`date +%Y%m%d`.log"
exec 1>$logfile 2>&1

# create local user
sudo useradd $user_account -s /bin/bash -m
chmod 700 $home

# stage1 key
sudo mkdir -p $home/.ssh --mode=700
sudo ssh-keygen -b 2048 -t rsa -f $home/.ssh/$user_account -q -N ""
sudo mv $home/.ssh/$user_account.pub $home/.ssh/authorized_keys

# stage2 key
ssh-keygen -b 2048 -t rsa -f $tmp_dir/$user_account -q -N ""
sudo mv $tmp_dir/$user_account $home/.ssh/id_rsa
	#-- private key for login stage2: $home/.ssh/id_rsa
sudo chown $user_account: $home/.ssh/ -R

# check stage1 ssh allowusers
check_user=`cat /etc/ssh/sshd_config | grep $user_account`
if [[ -n $check_user ]]; then
	echo "$user_account already existed, nothing to do."
else
	echo "add $user_account to ssh allow user."
	sudo sed -i "/^AllowUsers/s/$/ ${user_account}/" /etc/ssh/sshd_config
	sudo systemctl reload sshd
fi

# save user info to remote database
#stage1_user_pubkey=`sudo cat $home/.ssh/authorized_keys`
#stage1_user_prikey=`sudo cat $home/.ssh/$user_account`
#stage2_user_pubkey=`sudo cat $tmp_dir/$user_account.pub`
#stage2_user_prikey=`sudo cat $home/.ssh/id_rsa`

#mysql --login-path=remote --host=ssh_mgm keys-db << EOF
#	INSERT INTO stage1_users (user_account, user_group, user_pubkey, user_prikey, user_create, user_update) \
#	VALUES ("$user_account", "$user_group", "$stage1_user_pubkey", "$stage1_user_prikey", NOW(), NOW()); \
#	INSERT INTO stage2_users (user_account, user_group, user_pubkey, user_prikey, user_create, user_update) \
#	VALUES ("$user_account", "$user_group", "$stage2_user_pubkey", "$stage2_user_prikey", NOW(), NOW()); 
#EOF

mysql --login-path=remote --host=ssh_mgm keys-db << EOF
    INSERT INTO stage1_users (user_account, user_group, user_create) \
    VALUES ("$user_account", "$user_group", NOW()); \
    INSERT INTO stage2_users (user_account, user_group, user_create, user_update) \
    VALUES ("$user_account", "$user_group", NOW(), NOW()); 
EOF

# deploy new user to ssh_mgm
cp $create_tamplate playbook/user/create_user_${user_account}.yaml
sed -i s/user_account/${user_account}/g playbook/user/create_user_${user_account}.yaml
sed -i s/user_group/${user_group}/g playbook/user/create_user_${user_account}.yaml

ansible-playbook playbook/user/create_user_${user_account}.yaml
