#!/bin/bash
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# n: the number of temperatures to analyse
read n
# temps: the n temperatures expressed as integers ranging from -273 to 5526
read temps

# Write an action using echo
# To debug: echo "Debug messages..." >&2
distance=''
value=''

abs() {
    if (( $1 < 0 )); then
        x=$(( -$1 ))
        return $x
    else
        return $1
    fi
}


if [[ -z "$temps" ]]; then
    echo 0
    exit 0
fi

for i in $temps; do
    idist=$i
    abs $idist
    idist=$?
    if [[ -z "$value" ]]; then
        value=$i
        distance=$idist
    else
        if (( $idist < $distance )); then
            value=$i
            distance=$idist
        else
            if (( $idist == $distance )); then
                if (( $value < $i )); then
                    value=$i
                    distance=$idist
                fi
            fi
        fi
    fi
done

echo $value
