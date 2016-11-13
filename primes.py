#!/usr/bin/python3
import sys
import math

# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

def is_prime(n):
    for i in range(n-1, 2, -1):
        if n % i == 0:
            return False
    return True

def get_next_prime(n):
    nex = n +1
    while not is_prime(nex):
        nex += 1
    return nex
    
def get_prev_prime(n):
    prev = n - 1
    while not is_prime(prev) and prev > 0:
        prev -= 1
    return prev


n = int(input())



print(is_prime(n), file=sys.stderr)
print(get_next_prime(n), file=sys.stderr)
print(get_prev_prime(n), file=sys.stderr)
if n < (get_next_prime(n) + get_prev_prime(n)) * 0.5:
    print('WEAK')
elif n == (get_next_prime(n) + get_prev_prime(n)) * 0.5:
    print('BALANCED')
else:
    print('STRONG')


