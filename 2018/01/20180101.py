import sys
t = 0
for line in sys.stdin:
    if line.startswith("+"):
        t += int(line.strip()[1:])
    else:
        t -= int(line.strip()[1:])
print(t)

