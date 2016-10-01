#!/bin/bash
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
# ---
# Hint: You can use the debug stream to print initialTX and initialTY, if Thor seems not follow your orders.

# lightX: the X position of the light of power
# lightY: the Y position of the light of power
# initialTX: Thor's starting X position
# initialTY: Thor's starting Y position
read lightX lightY initialTX initialTY

currentX=$initialTX
currentY=$initialTY

declare -A dirs
dirs[0]=NW
dirs[1]=N
dirs[2]=NE
dirs[3]=W
dirs[4]=noting
dirs[5]=E
dirs[6]=SW
dirs[7]=S
dirs[8]=SE

# game loop
while true; do
    # remainingTurns: The remaining amount of turns Thor can move. Do not remove this line.
    read remainingTurns

    # Write an action using echo
    # To debug: echo "Debug messages..." >&2
    stepX=0
    if (( $currentX < $lightX )); then
        stepX=1;
    fi
    if (( $currentX > $lightX )); then
        stepX=-1;
    fi
    
    stepY=0
    if (( $currentY < $lightY )); then
        stepY=1;
    fi
    if (( $currentY > $lightY )); then
        stepY=-1;
    fi

    desc=$(( ($stepY + 1) * 3 + ($stepX + 1) ))
    
    currentX=$(( $currentX + $stepX ))
    currentY=$(( $currentY + $stepY ))

    # A single line providing the move to be made: N NE E SE S SW W or NW
    echo ${dirs[$desc]}
done
