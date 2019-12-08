import sys
import itertools
from typing import List,Tuple,Generator,Dict

def get_parameter(prog: List[int], operand: int, mode: int) -> int:
    return operand if mode == 1 else prog[operand]

def run_program(me: int, prog: List[int]) -> Generator[int,int,None]:
    prog = prog[:]  ##make it safe
    outp: List[int] = []
    pc = 0
    while True:
        if prog[pc] == 99:
            break

        o = prog[pc]
        op = o % 100
        m = [(o//i)%10 for i in [100,1000,10000]]

        if op == 1 or op == 2:
            a = get_parameter(prog, prog[pc+1], m[0])
            b = get_parameter(prog, prog[pc+2], m[1])
            ci = prog[pc+3]
            if op == 1:
                prog[ci] = a + b
            else:
                prog[ci] = a * b
            pc += 4
        elif op == 3:
            n = (yield -1)
            print("ME",me,"GOT",n)
            i = prog[pc+1]
            prog[i] = n
            pc += 2
        elif op == 4:
            n = get_parameter(prog, prog[pc+1], m[0])
            print("ME",me,"SENDING",n)
            yield n
            pc += 2
        elif op == 5 or op == 6:
            a = get_parameter(prog, prog[pc+1], m[0])
            b = get_parameter(prog, prog[pc+2], m[1])
            if (op == 5 and a != 0) or (op == 6 and a == 0):
                pc = b
            else:
                pc += 3
        elif op == 7 or op == 8:
            a = get_parameter(prog, prog[pc+1],m[0])
            b = get_parameter(prog, prog[pc+2], m[1])
            ci = prog[pc+3]
            prog[ci] = 1 if ((op == 7 and a < b) or (op == 8 and a == b)) else 0
            pc += 4
        else:
            assert False # wtf

def chain_amps(prog: List[int], phases: List[int]) -> int:
    sig = 0
    np = len(phases)
    rp: Dict[int,Generator[int,int,None]] = {}
    for i,ph in enumerate(phases):
        rp[i] = run_program(i, prog)
        next(rp[i])
        rp[i].send(ph)

    i = 0
    while True:
        rp[i].send(sig)
        next(rp[i])
        sig = next(rp[i])
        print("I AM HERe AND GOT", sig)
        i = (i + 1) % np

    return sig


def part_one(prog: List[int]) -> Tuple[int,List[int]]:
    mxsig = -99999999999
    mxperm : List[int] = []
    for p in itertools.permutations(range(5)):
        pl = list(p)
        sig = chain_amps(prog, pl)
        if sig > mxsig:
            mxsig = sig
            mxperm = pl
    return (mxsig,mxperm)

def rc(s: str) -> List[int]:
    return [int(n) for n in s.split(",")]

#assert part_one(rc("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")) == (43210,[4,3,2,1,0])
#assert part_one(rc("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")) == (54321,[0,1,2,3,4])
#assert part_one(rc("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")) == (65210,[1,0,4,3,2])

def main():
    #sg,prm = part_one(rc(open("input.txt").read()))
    #print(sg,prm)
    print(chain_amps(rc("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"), [9,8,7,6,5]))

if __name__ == '__main__':
    main()

