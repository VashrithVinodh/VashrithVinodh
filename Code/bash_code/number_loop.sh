#!/usr/bin/env bash

for i in $(seq 5 15); do
    echo "line $i"
done

for ((i = 5; i <= 15; i++)); do
    echo -n "$i "
done