#!/usr/bin/python
import sys
import math

while True:
    hs = [int(raw_input()) for i in xrange(8)]
    maxv = max(hs)
    maxp = hs.index(maxv)
    print maxp

