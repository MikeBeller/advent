import sys
sys.setrecursionlimit(10000)

INITIAL_STATE = ('home', 'home', 'home', 'home')
GOAL_STATE = ('market', 'market', 'market', 'market')

def hen_eats_corn(_, hen, corn, farmer):
    return hen == corn and not hen == farmer

def fox_eats_hen(fox, hen, _, farmer):
    return fox == hen and not hen == farmer

def valid_state(fox, hen, corn, farmer):
    return (not hen_eats_corn(fox, hen, corn, farmer)
            and not fox_eats_hen(fox, hen, corn, farmer))

assert not valid_state('home', 'home', 'market', 'market')
assert not valid_state('home', 'market', 'market', 'home')
assert valid_state('home', 'market', 'market', 'market')

def move(state, who):
    fox, hen, corn, farmer = state
    where = 'market' if farmer == 'home' else 'home'
    match who:
        case 'fox': return (where, hen, corn, where)
        case 'hen': return (fox, where, corn, where)
        case 'corn': return (fox, hen, where, where)
        case 'farmer': return (fox, hen, corn, where)
    assert False


assert move(INITIAL_STATE, 'farmer') == ('home', 'home', 'home', 'market')
assert move(INITIAL_STATE, 'hen') == ('home', 'market', 'home', 'market')

def all_moves(state):
    return [move(state, whom) for whom in ['fox', 'hen', 'corn', 'farmer']]

def solve(path):
    if path[-1] == GOAL_STATE:
        return path
    for next_state in all_moves(path[-1]):
        if valid_state(*next_state):
            return solve(path + (next_state,))
    assert False

result = solve((INITIAL_STATE,))
print(result)
