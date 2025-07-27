#!/usr/bin/env bash

d1=$(($RANDOM % 6 + 1))
d2=$(($RANDOM % 6 + 1))

echo -e "Dice 1: $d1\nDice 2: $d2"

TOT=$(($d1 + $d2))

echo "The total is $TOT"