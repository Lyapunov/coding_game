#!/usr/bin/python3
import sys
import math

n = int(input())  # the number of temperatures to analyse
raw = input()  # the n temperatures expressed as integers ranging from -273 to 5526

if raw:
    temps = [int(x) for x in raw.split(' ')]
    temps.sort(key=lambda x : abs(x)-(1 if x > 0 else 0))
    print( temps[0] )
else:
    print( 0 )

