#!/bin/bash

read MESSAGE

# Write an action using echo
# To debug: echo "Debug messages..." >&2

if (( ${#MESSAGE} == 0 )); then
    exit 0;
fi

abbord=""
for pos in $(seq 1 ${#MESSAGE}); do
    i=${MESSAGE:$pos-1:$pos}
    iord=`printf '%d' "'$i"`
    bord=`echo "obase=2;$iord" | bc`
    bosize=${#bord}
    bolead=""
    while (( $bosize < 7 )); do
        bolead="0"$bolead
        ((bosize++))
    done
    bbord="$bolead$bord"
    abbord="$abbord$bbord"
done

current=`echo $abbord | cut -c1`
myctr=0
desci=""
first=1

sabbord=`echo $abbord | fold -w1`
for i in $sabbord; do
    if (( $i == $current )); then
        ((myctr++))
        desci="0$desci"
    else
        currentz=""
        if (( $current == 0 )); then
            currentz="00"
        else 
            currentz="0"
        fi
        
        if (( $first == 1 )); then
            first=0
        else
            echo -n " "
        fi
        echo -n "$currentz $desci"
        current=$i
        desci="0"
        myctr=1
    fi
done

currentz=""
if (( $current == 0 )); then
    currentz="00"
else 
    currentz="0"
fi

if (( $first == 1 )); then
    first=0
else
    echo -n " "
fi
echo "$currentz $desci"
