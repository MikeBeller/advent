from typing import List

def read_data(instr: str) -> List[bytearray]:
    return [ bytearray(line.rstrip(), 'utf-8')
        for line in instr.splitlines()]


print(read_data(" /-->--\ "))
