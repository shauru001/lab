#!/bin/bash

tmp_dir="playbook/user/.pubkey"
create_tamplate="playbook/user/create_user.yaml"
user_account=$1
user_group=$2

# create user & key
sudo useradd $user_account -s /bin/bash -m
ssh-keygen -b 2048 -t rsa -f $tmp_dir/$user_account -q -N ""

user_pubkey=`cat $tmp_dir/$user_account.pub`
user_prikey=`cat $tmp_dir/$user_account`

# save key to database
mysql --login-path=remote --host=ssh_mgm keys-db << EOF
	INSERT INTO users (user_account, user_pubkey, user_prikey, user_create) \
	VALUES ("$user_account", "$user_pubkey", "$user_prikey", NOW());
EOF

# deploy new user to ssh_mgm
cp $create_tamplate playbook/user/create_user_${user_account}.yaml
sed -i s/user_account/${user_account}/g playbook/user/create_user_${user_account}.yaml
sed -i s/user_group/${user_group}/g playbook/user/create_user_${user_account}.yaml

ansible-playbook playbook/user/create_user_${user_account}.yaml

# move prikey
sudo mkdir -p /home/$user_account/.ssh --mode=700
sudo mv $tmp_dir/$user_account /home/$user_account/.ssh/id_rsa
sudo chown $user_account: /home/$user_account/.ssh/ -R
