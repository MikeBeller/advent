from typing import List,DefaultDict,Iterable
from collections import defaultdict

class Intcode:
    def __init__(self, prog: List[int], input: Iterable[int]) -> None:
        self.memory: DefaultDict[int, int] = defaultdict(int)
        for i,v in enumerate(prog):
            self.memory[i] = v
        self.input = iter(input)
        self.output: List[int] = []
        self.pc = 0
        self.relative_base = 0

    def get_mem(self, addr: int) -> int:
        assert addr >= 0
        return self.memory[addr]

    def set_mem(self, addr: int, val: int) -> None:
        assert addr >= 0
        self.memory[addr] = val

    def get_parameter(self, addr: int, mode: int) -> int:
        param = self.get_mem(addr)
        if mode == 1: # immediate
            r = param
        elif mode == 0: # direct
            r = self.get_mem(param) 
        else: # relative
            r = self.get_mem(param + self.relative_base)
        #print("GET", addr, param, mode, "GOT", r)
        return r

    def set_parameter(self, addr: int, mode: int, val: int) -> None:
        assert mode != 1, "Can't store to immediate address"
        param = self.get_mem(addr)
        if mode == 0:
            #print("setting", param, "to", val)
            self.set_mem(param, val)
        else:
            #print("setting", self.relative_base + param, "to", val)
            self.set_mem(self.relative_base + param, val)

    def run(self) -> None:
        while self.step() != 99:
            pass

    def run_to_event(self) -> int:
        while True:
            ev = self.step()
            if ev in [99, 3, 4]:
                break
        return ev

    def step(self) -> int:
        o = self.get_mem(self.pc)
        if o == 99:
            return 99

        op = o % 100
        m = [(o//i)%10 for i in [100,1000,10000]]

        if op == 1 or op == 2:
            a = self.get_parameter(self.pc+1, m[0])
            b = self.get_parameter(self.pc+2, m[1])
            if op == 1:
                self.set_parameter(self.pc+3, m[2], a + b)
            else:
                self.set_parameter(self.pc+3, m[2], a * b)
            self.pc += 4
        elif op == 3:
            n = next(self.input)
            self.set_parameter(self.pc+1, m[0], n)
            self.pc += 2
        elif op == 4:
            n = self.get_parameter(self.pc+1, m[0])
            self.output.append(n)
            self.pc += 2
        elif op == 5 or op == 6:
            a = self.get_parameter(self.pc+1, m[0])
            b = self.get_parameter(self.pc+2, m[1])
            if (op == 5 and a != 0) or (op == 6 and a == 0):
                self.pc = b
            else:
                self.pc += 3
        elif op == 7 or op == 8:
            a = self.get_parameter(self.pc+1, m[0])
            b = self.get_parameter(self.pc+2, m[1])
            if ((op == 7 and a < b) or (op == 8 and a == b)):
                self.set_parameter(self.pc+3, m[2], 1)
            else:
                self.set_parameter(self.pc+3, m[2], 0)
            self.pc += 4
        elif op == 9:
            a = self.get_parameter(self.pc+1, m[0])
            self.relative_base += a
            self.pc += 2
        else:
            assert False, "Invalid opcode: " + str(op)

        return op

def intcode_test(prgstr: str, inp: List[int]) -> List[int]:
    prog = [int(s) for s in prgstr.split(",")]
    ic = Intcode(prog, inp)
    ic.run()
    return ic.output

def run_tests() -> None:
    # day 5 base tests
    assert intcode_test("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [0]) == [0]
    assert intcode_test("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [1]) == [1]
    assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [5]) == [999]
    assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [8]) == [1000]
    assert intcode_test("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [9]) == [1001]

    # day 9 tests
    assert intcode_test("1102,34915192,34915192,7,4,7,99,0",[]) == [1219070632396864]
    assert intcode_test("104,1125899906842624,99", []) == [1125899906842624]
    assert intcode_test("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", []) == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    print("OK")

if __name__ == '__main__':
    run_tests()
