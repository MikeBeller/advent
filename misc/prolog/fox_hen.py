INITIAL_STATE = dict(fox='home', hen='home', corn='home', farmer='home')
GOAL_STATE = dict(fox='market', hen='market', corn='market', farmer='market')

def is_safe_state(s):
    return not ((s['farmer'] != s['hen']) and
        (s['fox'] == s['hen'] or s['hen'] == s['corn']))

assert not is_safe_state(dict(fox='home', hen='home', corn='market', farmer='market'))
assert not is_safe_state(dict(fox='home', hen='market', corn='market', farmer='home'))
assert is_safe_state(dict(fox='home', hen='market', corn='market', farmer='market'))

def move(s, other):
    nxt = 'market' if s['farmer'] == 'home' else 'home'
    s2 = dict(s, **{'farmer': nxt, other: nxt} )
    assert is_safe_state(s2)
    return s2

assert move(INITIAL_STATE, 'farmer') == dict(fox='home', hen='home', corn='home', farmer='market')
assert move(INITIAL_STATE, 'hen') == dict(fox='home', hen='market', corn='home', farmer='market')

def legal_moves(s):
    # farmer can move by himself, or with any one other item in the same place as him:
    return [next_state for other in ['fox', 'hen', 'corn', 'farmer']
        if s['farmer'] == s[other] and
            is_safe_state(next_state := move(s,other))]

def solve(path):
    if path[-1] == GOAL_STATE:
        return path
    for next_state in legal_moves(path[-1]):
        return solve(moves + (next_state))

result = solve((INITIAL_STATE,))
print(result)
