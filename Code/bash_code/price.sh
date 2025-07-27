#!/bin/bash

echo -n "Provide a quantity: "
read QTY

echo "The quantity is $QTY"

read -p "Enter the price: " PRICE
TOT=$(($PRICE * $QTY))

echo "The total is \$$TOT"