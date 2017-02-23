#!/usr/bin/python
import sys
import math

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

# w: width of the building.
# h: height of the building.
w, h = [int(i) for i in input().split()]
n = int(input())  # maximum number of turns before game over.
x0, y0 = [int(i) for i in input().split()]


def translate( desc ):
    x, y = 0, 0
    if desc.startswith('U'):
        y = -1
    else:
        if desc.startswith('D'):
            y = 1
    if desc.endswith('L'):
        x = -1
    else:
        if desc.endswith('R'):
            x = 1
    return (x,y) 
    
def selector( sel, first, second, third ):
    if sel == -1:
        return first
    if sel == 0:
        return second
    if sel == 1:
        return third

dx, dy = translate( input() )
x1 = selector(dx, 0, x0, w)
y1 = selector(dy, 0, y0, h)

if x1 < x0:
    x0, x1 = x1, x0

if y1 < y0:
    y0, y1 = y1, y0
    
# game loop
while True:
    # next gues
    gx = int((x0 + x1) / 2)
    gy = int((y0 + y1) / 2)
    
    print( gx, gy )
    dir = input()
    dx, dy = translate( dir  )
    sys.stderr.write( dir + '\n' )
    sys.stderr.write( str(dx) )
    sys.stderr.write( str(dy) )
    
    if dx == 0:
        x0 = gx
        x1 = gx
    else:
        if dx == 1:
            x0 = gx
        else:
            x1 = gx

    if dy == 0:
        y0 = gy
        y1 = gy
    else:
        if dy == 1:
            y0 = gy
        else:
            y1 = gy

