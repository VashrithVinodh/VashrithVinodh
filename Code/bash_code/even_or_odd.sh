#!/usr/bin/env bash

read -p "Give me a number! " NUM

echo "Read in: $NUM"

if [ $(($NUM % 2)) -eq 0 ]; then
    echo "Your number is even"

elif [ $(($NUM % 2)) -eq 1 ]; then
    echo "Your number is odd"

fi