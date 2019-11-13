import sys
import itertools

def read_list():
    r = []
    for line in sys.stdin:
        if line.startswith("+"):
            r.append(int(line.strip()[1:]))
        else:
            r.append(-int(line.strip()[1:]))
    return r

def main():
    xs = read_list()
    fs = {}
    f = 0
    for x in itertools.cycle(xs):
        if f in fs:
            print(f)
            break
        fs[f] = True
        f += x

if __name__ == '__main__':
    main()
