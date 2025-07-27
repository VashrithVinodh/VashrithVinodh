#!/usr/bin/env bash

d1=$(($RANDOM % 6 + 1))
echo $d1

if [ $(($d1 % 3)) -eq 0 ]; then
    echo -n "super cool message"
fi

echo "End of program"

echo