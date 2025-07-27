#!/bin/bash

scp "$1" root@"$2":/tmp/supplemental_groups.txt

ssh root@$2 << 'EOF'
    while read -r line; do
        username=$(cut -d: -f1 <<< "$line")
        groups=$(cut -d: -f2 <<< "$line")
        usermod -aG "$groups" "$username"

    done < /tmp/supplemental_groups.txt
EOF