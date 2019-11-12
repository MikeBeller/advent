import sys

def main():
    xs = [line.strip() for line in sys.stdin]
    assert all(len(x) == len(xs[0]) for x in xs)
    n = len(xs[0])
    for i in range(n):
        t = {}
        for x in xs:
            y = x[:i] + x[i+1:]
            if y in t:
                print(y)
                sys.exit(0)
            t[y] = True


if __name__ == '__main__':
    main()
