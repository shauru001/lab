1. init group & sudoers:

structure:

scripts
  group_init.sh => playbook/group_init.yml #ubuntu@ansible3:~/project/ssh_mgt/lab/playbook
  e.g: ./group_init.sh ${site}

ansible
  playbook
    group_init.yml => include role: group_auth
                   => hosts: group_init
    user_create.yml
    user_remove.yml
    user_rotate.yml

    roles
      group_auth  => add group, sudoer config

  inventories/local-test
    [group_init]


user_group:

 - op_group: sudo, systemd restart
 - rd_group: systemd status, cat, ls, du
 - ci_group: sudo, systemd restart

===================================================
2. create user & key & join group:

structure:

scripts
  user_create.sh => playbook/user_create.yml
  e.g: ./user_create.sh ${site} ${username} ${groupname}

ansible
  playbook
    user_create.yml

    roles
      user_mode
        tasks/create.yml

output
  user_list.csv => user info, key time (epoch)


===================================================
3. key rotate:

  - check key expiration
  - gen new key
  - test
  - delete old key# lab
