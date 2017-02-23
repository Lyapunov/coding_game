#!/usr/bin/python

n = int(input())
pis = [int(input()) for i in range(n)]
pis.sort()
diffs = [(b-a) for a, b in zip(pis, pis[1:])]

print( min(diffs) )
