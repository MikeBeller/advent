from enum import Enum
import dataclasses as dc
from dataclasses import dataclass

class Loc(Enum):
    HOME = 1
    MARKET = 2

@dataclass
class State:
    fox: Loc
    hen: Loc
    corn: Loc
    farmer: Loc

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


assert move(INITIAL_STATE, 'farmer') == (HOME, HOME, HOME, MARKET)
assert move(INITIAL_STATE, 'hen') == (HOME, MARKET, HOME, MARKET)

def all_moves(state):
    return [move(state, whom) for whom in ['fox', 'hen', 'corn', 'farmer']]

def solve_bfs():
    mxlen = 1
    paths = ((INITIAL_STATE,))
    while paths:
        *paths, path = paths
        paths = tuple(paths)
        for nxt in all_moves(path[-1]):
            if valid_state(*nxt):
                new_path = path + (nxt,)
                print(new_path)
                if len(new_path) > mxlen:
                    print("mxlen:", mxlen)
                    mxlen = len(new_path)
                    if mxlen > 5:
                        return None
                if nxt == GOAL_STATE:
                    return new_path
                else:
                    paths = paths + (new_path,)
 

print(solve_bfs())
