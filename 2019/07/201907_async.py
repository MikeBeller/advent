import sys
import itertools
from typing import List,Tuple,Generator,Dict
import asyncio

def get_parameter(prog: List[int], operand: int, mode: int) -> int:
    return operand if mode == 1 else prog[operand]

async def run_program(me: int, prog: List[int], inp: asyncio.Queue, out: asyncio.Queue) -> None:
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
            n = await inp.get()
            #print(me, "got", n)
            i = prog[pc+1]
            prog[i] = n
            pc += 2
        elif op == 4:
            n = get_parameter(prog, prog[pc+1], m[0])
            #print(me, "sending", n)
            await out.put(n)
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

async def async_chain_amps(prog: List[int], phases: List[int]) -> int:
    np = len(phases)
    queues: Dict[int,asyncio.Queue] = {}
    for i,ph in enumerate(phases):
        queues[i] = asyncio.Queue()
        await queues[i].put(ph)

    tasks: List[asyncio.Task] = []
    for i in range(np):
        tasks.append(
                asyncio.create_task(
                    run_program(i, prog, queues[i], queues[(i+1)%np])))

    sig = 0
    await queues[0].put(sig)
    await asyncio.gather(*tasks)
    sig = await queues[0].get()
    return sig

def chain_amps(prog: List[int], phases: List[int]) -> int:
    return asyncio.run(async_chain_amps(prog, phases))

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

def main() -> None:
    sg,prm = part_two(rc(open("input.txt").read()))
    print(sg,prm)

if __name__ == '__main__':
    main()

