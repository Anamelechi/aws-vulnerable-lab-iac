[public]
public_instance ansible_host=${public_ip}

[private]
private_instance ansible_host=${private_ip}
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q -i ${key_path} ${user}@${public_ip}"'