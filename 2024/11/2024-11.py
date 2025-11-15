def main():
    stones = [int(s) for s in open("input.txt").read().split()]
    #stones = [0]
    for i in range(25):
        print(i,len(stones))
        new = []
        for s in stones:
            if s == 0:
                new.append(1)
            else:
                digs = str(s)
                l = len(digs)
                if l % 2 == 0:
                    l2 = l//2
                    new.append(int(digs[:l2]))
                    new.append(int(digs[l2:]))
                else:
                    new.append(2024*s)
        stones = new
    #print(len(stones),stones)
    print(len(stones))

main()
