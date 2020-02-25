
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None
        self.prev = None

    def insert_next(self, val):
        nn = Node(val)
        nn.next = self.next
        nn.prev = self
        self.next = nn
        nn.next.prev = nn

    def delete_prev(self):
        self.prev.prev.next = self
        self.prev = self.prev.prev

    def to_list(self):
        cm = self.next
        l = [self.val]
        while cm != self:
            l.append(cm.val)
            cm = cm.next
        return l

def test_list():
    n = Node(1)
    n.next = n
    n.prev = n
    n.insert_next(2)
    assert n.to_list() == [1,2]
    n = n.next
    n.insert_next(3)
    assert n.to_list() == [2, 3, 1]
    n = n.next
    n.delete_prev()
    assert n.to_list() == [3, 1]

test_list()

def game(n_players: int, max_marble: int) -> int:
    scores = [0]*n_players
    cm = Node(0)
    cm.next = cm
    cm.prev = cm
    for marblenum in range(1, max_marble+1):
        playernum = (marblenum-1) % n_players
        if marblenum % 23 != 0:
            cm = cm.next
            cm.insert_next(marblenum)
            cm = cm.next
        else:
            scores[playernum] += marblenum
            for i in range(7):
                cm = cm.prev
            scores[playernum] += cm.val
            cm = cm.next
            cm.delete_prev()
    return max(scores)
            
assert game(9, 25) == 32
assert game(10, 1618) == 8317
assert game(13, 7999) == 146373

def main():
    ans1 = game(441, 71032)
    print("PART1: ", ans1)

    ans2 = game(441, 7103200)
    print("PART2: ", ans2)


main()




