import sys
import math

while True:
    hs = [int(input()) for i in range(8)]
    maxv = max(hs)
    maxp = hs.index(maxv)
    print( maxp )
