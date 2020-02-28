from typing import Tuple, DefaultDict

def read_data(fpath: str) -> Tuple[str, DefaultDict[str,str]]:
    init = ""
    conv: DefaultDict[str,str] = DefaultDict(lambda: ".")
    for line in open(fpath):
        f = line.strip().split()
        if len(f) != 3:
            continue
        if f[0] == "initial":
            init = f[2]
            continue
        assert f[1] == "=>"
        conv[f[0]] = f[2]
    return (init, conv)

def run_sim(state: str, n: int, conv: DefaultDict[str,str]) -> str:
    s = "...." + state + "...."
    for si in range(n):
        s = ".." + "".join(
                conv[s[i:i+5]] for i in range(len(s)-4)).rstrip('.') + "...."
    return s.rstrip('.')

def score(st: str) -> int:
    return sum((i-4) if st[i] == '#' else 0 for i in range(len(st)))

def part1(inpath: str) -> int:
    init, conv = read_data(inpath)
    fs = run_sim(init, 20, conv)
    sc = score(fs)
    return sc

assert part1("tinput.txt") == 325

def checker() -> None:
    for i,line in enumerate(open("t2input.txt")):
        st = line.strip().split()[1]
        print(i, score(st), st)

def part2(inpath: str) -> int:
    # after 101th iteration it seems just to move to the right one
    # square for each subsequent iteration
    init, conv = read_data(inpath)
    fs = run_sim(init, 101, conv)
    sc = score(fs)

    # moving to the right "delta" squares just adds to the total
    # score an amount equal to delta * num_plants, where num_plants
    # is the number of live plants when the pattern stabilizes
    # so just adjust for that
    delta = 50000000000 - 101
    num_plants = sum(p == "#" for p in fs)
    final_score = sc + delta * num_plants
    return final_score

def main() -> None:
    ans1 = part1("input.txt")
    print("PART1:", ans1)

    ans2 = part2("input.txt")
    print("PART2:", ans2)

main()

