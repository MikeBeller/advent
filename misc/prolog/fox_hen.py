from dataclasses import dataclass
from enum import StrEnum

class Loc(StrEnum):
    HOME = 'home'
    CART = 'cart'
    MARKET = 'market'

@dataclass
class State:
    fox: Loc
    hen: Loc
    corn: Loc
    farmer: Loc

INITIAL_STATE = State('home', 'home', 'home', 'home')
GOAL_STATE = State('market', 'market', 'market', 'market')

def is_legal_state(s: State) -> bool:
    # if the fox and the hen are together without the farmer -- opsie:
    if s.fox == s.hen and not s.farmer = s.hen:
        return False
    elif s.hen == s.corn and not s.farmer = s.corn:
        return False
    else:
        return True


