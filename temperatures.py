#!/usr/bin/python
import sys
import math

n = int(raw_input())  # the number of temperatures to analyse
raw = raw_input()
if raw:
    temps = [int(x) for x in raw.split(' ')]
    temps.sort(key=lambda x : abs(x)-(1 if x > 0 else 0))
    print temps[0]
else:
    print 0

