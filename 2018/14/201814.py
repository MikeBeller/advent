
from typing import List

def digits(n: int):
    return [int(d) for d in str(n)]

class State:
    def __init__(self, _scores: List[int]):
        self.scores: List[int] = _scores
        self.elves = [0, 1]
    
    def step(self) -> int:
        r = 1
        ln = len(self.scores)
        s = sum(self.scores[e] for e in self.elves)
        #self.scores.extend(digits(s)) # 33 % slower
        if s > 9: # max of s is 19
            self.scores.append(1)
            s -= 10
            r = 2
        self.scores.append(s)
        self.elves = [
            (e + 1 + self.scores[e]) % len(self.scores)
            for e in self.elves
        ]
        return r
                
def scores_after_n(scores: List[int], n: int) -> List[int]:
    st = State(scores)
    while len(st.scores) < n + 10:
        st.step()
    return(st.scores[n:n+10])

def part1(n):
    ds = scores_after_n([3,7], n)
    return "".join(str(d) for d in ds)

assert part1(9) == "5158916779"
assert part1(5) == "0124515891"
assert part1(18) == "9251071085"
assert part1(2018) == "5941429882"

print("PART1:", part1(330121))

def part2(inp) -> int:
    st = State([3,7])
    ln = len(inp)
    while True:
        n = st.step()
        if st.scores[-ln-1:-1] == inp:
            return len(st.scores) - ln - 1
        if st.scores[-ln:] == inp:
            return len(st.scores) - ln

assert part2([5,1,5,8,9]) == 9
assert part2([0,1,2,4,5]) == 5
assert part2([9,2,5,1,0]) == 18
assert part2([5,9,4,1,4]) == 2018

print("PART2:", part2(digits(330121)))
