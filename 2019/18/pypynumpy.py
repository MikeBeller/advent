# pip install pytest-benchmark
# pytest pypynumpy.py

import numpy as np
import random
import array

def add_array(a):
    s = 0
    for i in range(len(a)):
        s += a[i]
    return s

def add_nparray(a):
    s = 0
    nr,nc = a.shape
    for r in range(nr):
        for c in range(nc):
            s += a[r][c]
    return s

def add_list_list(a):
    s = 0
    nr = len(a)
    nc = len(a[0])
    for r in range(nr):
        for c in range(nc):
            s += a[r][c]
    return s

def add_list(a):
    s = 0
    for i in range(len(a)):
        s += a[i]
    return s

def test_numpy(benchmark):
    a = np.random.randint(0,1000000, (1000,1000))
    benchmark(add_nparray, a)

def test_array(benchmark):
    l = []
    for i in range(1000000):
        l.append(random.randint(0,999999))
    a = array.array('l', l)
    benchmark(add_array, a)

def test_list_list(benchmark):
    nr,nc = 1000,1000
    a = []
    for r in range(nr):
        a.append([0]*nc)
        for c in range(nc):
            a[r][c] = random.randint(0,999999)
    benchmark(add_list_list, a)

def test_list(benchmark):
    a = []
    for i in range(1000000):
        a.append(random.randint(0,999999))
    benchmark(add_list, a)

