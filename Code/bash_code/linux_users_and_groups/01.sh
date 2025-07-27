#!/bin/bash

scp "$1" root@"$2":/tmp/groups.txt

ssh root@$2 << 'EOF'
    while read -r line; do
        group=$(cut -d: -f1 <<< "$line")
        gid=$(cut -d: -f2 <<< "$line")
        groupadd -g "$gid" "$group"
    done < /tmp/groups.txt
EOF