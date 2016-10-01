#!/bin/bash

# game loop
while true; do
    maxH=''
    maxP=0
    for (( i=0; i<8; i++ )); do
        # mountainH: represents the height of one mountain.
        read mountainH
        if [ -z $maxH ]; then
            maxH=$mountainH
            maxP=$i
        fi
        if (( $mountainH > $maxH )); then
            maxH=$mountainH
            maxP=$i
        fi
    done

    # Write an action using echo
    # To debug: echo "Debug messages..." >&2

    echo $maxP # The index of the mountain to fire on.
done
