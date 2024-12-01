from numpy import *
input = loadtxt("input.txt", dtype=int)
a,b = input[:,0], input[:,1]
print(sum(abs(sort(a) - sort(b))))
r = bincount(b)
print(sum(a * r[a]))
