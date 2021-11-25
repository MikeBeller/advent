
from typing import List
from dataclasses import dataclass

def digits(n: int):
    return [int(d) for d in str(n)]

class State:
    def __init__(self, _scores: List[int]):
        self.scores: List[int] = _scores
        self.elves = [0, 1]
    
    def step(self):
        self.scores.extend(digits(sum(self.scores[e] for e in self.elves)))
        self.elves = [
            (e + 1 + self.scores[e]) % len(self.scores)
            for e in self.elves
        ]

def scores_after_n(scores: List[int], n: int) -> List[int]:
    st = State(scores)
    while len(st.scores) < n + 10:
        st.step()
    return st.scores[-10:]


assert scores_after_n([3,7], 9) == [5,1,5,8,9,1,6,7,7,9]
assert scores_after_n([3,7], 5) == [0,1,2,4,5,1,5,8,9,1]