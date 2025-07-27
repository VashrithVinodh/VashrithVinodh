#!/bin/bash

while read -r line; do
    left=$(cut -f 1 -d $2 <<< $line)
    right=$(cut -f 2 -d $2 <<< $line)
    
    #echo $left
    #echo $right

    if [ $left == $right ]; then
        echo "match: $left"
    else
        echo "no match"
    fi
done < $1