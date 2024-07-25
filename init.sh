#!/usr/bin/env bash

SSH_PORT="${SSH_PORT:-1082}"
USER_PASSWORD="${USER_PASSWORD:-UhbYgv876}"

pkg install -y \
    openssh

echo "${USER_PASSWORD}" | passwd --stdin

cat > /data/data/com.termux/files/usr/etc/ssh/sshd_config <<-EOF
Port ${SSH_PORT}
PrintMotd no
PasswordAuthentication no
PubkeyAcceptedKeyTypes +ssh-dss
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
EOF

nohup sshd &
