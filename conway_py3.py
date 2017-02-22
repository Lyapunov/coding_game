#!/usr/bin/python
import sys
import math

import resource
import sys

# Increasing recursion limit from 1000

#print resource.getrlimit(resource.RLIMIT_STACK)
#print sys.getrecursionlimit()
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
# Will segfault without this line.
resource.setrlimit(resource.RLIMIT_STACK, [0x10000000, resource.RLIM_INFINITY])
sys.setrecursionlimit(0x100000)

def nextLineInternal( lst, prv, count ):
    if ( lst == [] ):
        return [count, prv]
    if ( lst[0] == prv ):
        return nextLineInternal( lst[1:], prv, count+1 )
    else:
        return [count, prv] + nextLineInternal( lst[1:], lst[0], 1 )
    
def nextLine( lst ):
    return nextLineInternal( lst[1:], lst[0], 1)

r = int(input())
l = int(input())

s = [r]

for k in range(1,l):
    s = nextLine(s)
#    print s
    
print(*s)
