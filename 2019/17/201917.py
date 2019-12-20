import os
from intcode import Intcode

def main() -> None:
    prog = [int(s) for s in open("input.txt").read().strip().split(",")]
    ic = Intcode(prog)
    ic.run()
    for c in ic.output:
        print(chr(c),sep="",end="")


main()

