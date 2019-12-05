import sys
from typing import List,Tuple,TextIO

def read_data(infile: TextIO) -> List[int]:
    return [int(s) for s in infile.read().split(",")]

def get_parameter(prog: List[int], operand: int, mode: int) -> int:
    return operand if mode == 1 else prog[operand]

def run_program(prog: List[int]):
    pc = 0
    while True:
        if prog[pc] == 99:
            break
        else:
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
                n = int(input("input: "))
                i = prog[pc+1]
                prog[i] = n
                pc += 2
            elif op == 4:
                n = get_parameter(prog, prog[pc+1], m[0])
                print(n)
                pc += 2
            else:
                assert False # wtf

def main():
    with open(sys.argv[1]) as infile:
        prog = read_data(infile)
    run_program(prog)

if __name__ == '__main__':
    main()

