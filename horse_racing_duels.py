#!/usr/bin/python

n = int(raw_input())
pis = [int(raw_input()) for i in xrange(n)]
pis.sort()
diffs = [(b-a) for a, b in zip(pis, pis[1:])]

print( min(diffs) )
