def cl(n):
  c = 1
  while n > 1:
    n = n//2 if n & 1 == 0 else 3 * n + 1
    c += 1
  return c

print(max(cl(i) for i in range(1000000)))
