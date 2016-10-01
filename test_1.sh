#!/bin/bash

read x
echo $x

if (( $x > 10 )); then
   echo "That's great".
fi
