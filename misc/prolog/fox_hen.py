from enum import StrEnum
import dataclasses as dc
from dataclasses import dataclass

class Loc(StrEnum):
    HOME = 'H'
    MARKET = 'M'

@dataclass
class State:
    fox: Loc
    hen: Loc
    corn: Loc
    farmer: Loc

    def __repr__(self):
        return str(self.fox) + str(self.hen) + str(self.corn) + str(self.farmer)

HOME = Loc.HOME
MARKET = Loc.MARKET

INITIAL_STATE = State(HOME, HOME, HOME, HOME)
GOAL_STATE = State(MARKET, MARKET, MARKET, MARKET)

def hen_eats_corn(s: State) -> bool:
    return s.hen == s.corn and not s.hen == s.farmer

def fox_eats_hen(s: State) -> bool:
    return s.fox == s.hen and not s.hen == s.farmer

def valid_state(s: State) -> bool:
    return (not hen_eats_corn(s)
            and not fox_eats_hen(s))

assert not valid_state(State(HOME, HOME, MARKET, MARKET))
assert not valid_state(State(HOME, MARKET, MARKET, HOME))
assert valid_state(State(HOME, MARKET, MARKET, MARKET))

def move(s: State, who: str) -> State:
    where = MARKET if s.farmer == HOME else HOME
    match who:
        case 'fox': return dc.replace(s, fox=where, farmer=where)
        case 'hen': return dc.replace(s, hen=where, farmer=where)
        case 'corn': return dc.replace(s, corn=where, farmer=where)
        case 'farmer': return dc.replace(s, farmer=where)
    assert False


assert move(INITIAL_STATE, 'farmer') == State(HOME, HOME, HOME, MARKET)
assert move(INITIAL_STATE, 'hen') == State(HOME, MARKET, HOME, MARKET)

def all_moves(s:State) -> list[State]:
    return [move(s, whom) for whom in ['fox', 'hen', 'corn', 'farmer']]

def solve_bfs() -> list[State] | None:
    mxlen = 1
    paths: list[list[State]] = [[INITIAL_STATE]]
    while len(paths) > 0:
        path, *paths = paths
        for nxt in all_moves(path[-1]):
            if valid_state(nxt):
                new_path = path + [nxt]
                if nxt == GOAL_STATE:
                    return new_path
                else:
                    paths = paths + [new_path]
    assert False
 

print(solve_bfs())
