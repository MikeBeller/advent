import sys
from typing import List,Tuple,TextIO

def read_data(infile: TextIO) -> List[int]:
    return [int(s) for s in infile.read().split(",")]

def get_parameter(prog: List[int], operand: int, mode: int) -> int:
    return operand if mode == 1 else prog[operand]

def run_program(prog: List[int], inp: List[str]) -> List[str]:
    outp: List[str] = []
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
            n = int(inp.pop(0))
            i = prog[pc+1]
            prog[i] = n
            pc += 2
        elif op == 4:
            n = get_parameter(prog, prog[pc+1], m[0])
            outp.append(str(n))
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

    return outp

def test(tname: str, prg: str, instr: str, expect: str) -> bool:
    prog = [int(s) for s in prg.split(",")]
    inp = instr.split(",")
    exp = expect.split(",")
    out = run_program(prog, inp)
    if out != exp:
        print(tname, "Expected", exp, "got", out)
        return False
    return True

assert test("equal to 8", "3,9,8,9,10,9,4,9,99,-1,8", "8", "1")
assert test("not equal to 8", "3,9,8,9,10,9,4,9,99,-1,8", "-1", "0")
assert test("zero is zero", "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", "0", "0")
assert test("nonzero is 1", "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", "22", "1")
assert test("zero is zero immediate", "3,3,1105,-1,9,1101,0,0,12,4,12,99,1", "0", "0")
assert test("nonzero is one immediate", "3,3,1105,-1,9,1101,0,0,12,4,12,99,1", "-1", "1")

prgbig = """3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"""
assert test("big below 8", prgbig, "7", "999")
assert test("big equal 8", prgbig, "8", "1000")
assert test("big gt 8", prgbig, "9393", "1001")

def main():
    with open(sys.argv[1]) as infile:
        prog = read_data(infile)
    inp = sys.argv[2:]
    outp = run_program(prog, inp)
    print("\n".join(outp))

if __name__ == '__main__':
    main()

