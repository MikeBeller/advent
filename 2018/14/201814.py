
from typing import List

def digits(n: int):
    return [int(d) for d in str(n)]

class State:
    def __init__(self, _scores: List[int]):
        self.scores: List[int] = _scores
        self.elves = [0, 1]
    
    def step(self):
        s = sum(self.scores[e] for e in self.elves)
        #self.scores.extend(digits(s)) # 33 % slower
        if s > 9: # max of s is 19
            self.scores.append(1)
            s -= 10
        self.scores.append(s)
        self.elves = [
            (e + 1 + self.scores[e]) % len(self.scores)
            for e in self.elves
        ]

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