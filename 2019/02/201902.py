import sys
from typing import List,Tuple

def read_data() -> List[int]:
    return [int(s) for s in sys.stdin.read().split(",")]

def run_program(prog: List[int]) -> int:
    pc = 0
    while True:
        if prog[pc] == 99:
            break
        else:
            ai = prog[pc+1]
            bi = prog[pc+2]
            ci = prog[pc+3]
            if prog[pc] == 1:
                prog[ci] = prog[ai] + prog[bi]
            elif prog[pc] == 2:
                prog[ci] = prog[ai] * prog[bi]
            else:
                print("WtF", file=sys.stderr)
                sys.exit(1)
        pc += 4
    return prog[0]

def part1(prog: List[int]) -> int:
    p = prog[:]
    return run_program(p)

def part2(prog: List[int]) -> Tuple[int,int]:
    for noun in range(100):
        for verb in range(100):
            p = prog[:]
            p[1] = noun
            p[2] = verb
            r = run_program(p)
            if r == 19690720:
                return noun,verb
    print("WtF", file=sys.stderr)
    sys.exit(1)

def main():
    prog = read_data()
    ans1 = part1(prog)
    print(ans1)
    noun,verb = part2(prog)
    print(100 * noun + verb)

if __name__ == '__main__':
    main()

