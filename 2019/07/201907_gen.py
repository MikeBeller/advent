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
            i = prog[pc+1]
            prog[i] = n
            pc += 2
        elif op == 4:
            n = get_parameter(prog, prog[pc+1], m[0])
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
        if i not in rp:
            break
        sig = rp[i].send(sig)
        try:
            next(rp[i])
        except:
            del rp[i]
        i = (i + 1) % np

    return sig


def part_two(prog: List[int]) -> Tuple[int,List[int]]:
    mxsig = -99999999999
    mxperm : List[int] = []
    for p in itertools.permutations([5,6,7,8,9]):
        pl = list(p)
        sig = chain_amps(prog, pl)
        if sig > mxsig:
            mxsig = sig
            mxperm = pl
    return (mxsig,mxperm)

def rc(s: str) -> List[int]:
    return [int(n) for n in s.split(",")]

assert chain_amps(rc("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"), [9,8,7,6,5]) == 139629729

def main():
    sg,prm = part_two(rc(open("input.txt").read()))
    print(sg,prm)

if __name__ == '__main__':
    main()

