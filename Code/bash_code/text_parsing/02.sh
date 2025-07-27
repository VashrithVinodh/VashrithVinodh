#!/bin/bash

count=0
while read -r line; do
    check=$(cut -f 7 -d: <<< $line)

    if [ $check == $2 ]; then
        count=$(($count + 1))
    fi
done < $1

echo "Count of default shell set to $2: $count"