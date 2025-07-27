#!/bin/bash

while read -r line; do
    username=$(cut -f 1 -d: <<< $line)
    uid=$(cut -f 3 -d: <<< $line)
    home=$(cut -f 6 -d: <<< $line)

    echo "$username,$uid,$home"
done < $1