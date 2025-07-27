#!/bin/bash

scp "$1" root@"$2":/tmp/users.txt

ssh root@$2 << 'EOF'
    while read -r line; do
        username=$(cut -d: -f1 <<< "$line")
        gid=$(cut -d: -f2 <<< "$line")
        passwd=$(cut -d: -f3 <<< "$line")
        shell=$(cut -d: -f4 <<< "$line")
        useradd -g "$gid" -s "$shell" -m "$username"

        echo "$username:$passwd" | chpasswd

    done < /tmp/users.txt
EOF