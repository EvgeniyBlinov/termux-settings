#!/usr/bin/env bash

ACTION="${ACTION:-configure}"
[ -n "$1" ] && [ "x$1" == "xinit" ] && ACTION='init'

SSH_PORT="${SSH_PORT:-1082}"
USER_PASSWORD="${USER_PASSWORD:-UhbYgv876}"

function clear {
    echo "Clearing $PREFIX"
    ## https://github.com/termux/termux-app/issues/1703
    export PREFIX=/data/data/com.termux/files/usr
    export LD_LIBRARY_PATH=$PREFIX/lib
    export PATH="$PATH:$PREFIX/bin"
    curl -o $PREFIX/bin/termux-upgrade-repo https://raw.githubusercontent.com/termux/termux-packages/android-5/packages/termux-tools/termux-upgrade-repo
    chmod +x $PREFIX/bin/termux-upgrade-repo
    termux-upgrade-repo;

    pkg upgrade -y;
}

if [ "${ACTION}" == "init" ]; then
    clear
fi

pkg install -y \
    openssh

echo "${USER_PASSWORD}" | passwd --stdin ||
    printf "%s\n" "${USER_PASSWORD}" "${USER_PASSWORD}" | passwd

cat > /data/data/com.termux/files/usr/etc/ssh/sshd_config <<-EOF
Port ${SSH_PORT}
PrintMotd no
PasswordAuthentication no
#PubkeyAcceptedKeyTypes +ssh-dss
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
EOF

nohup sshd >/dev/null 2>&1 &
