
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None
        self.prev = None

    def insert_next(self, val):
        nn = Node(val)
        nn.next = self.next
        nn.prev = self
        nn.next.prev = nn

    def delete_prev(self):
        self.prev.prev.next = self
        self.prev = self.prev.prev

    def to_list(self):
        cm = self.next
        l = [self.val]
        while cm != self:
            l.append(self.val)
            cm = cm.next
        return l

def game(n_players: int, max_marble: int) -> int:
    scores = [0]*n_players
    cm = Node(0)
    cm.next = cm
    cm.prev = cm
    for marblenum in range(1, max_marble+1):
        print(cm.to_list())
        playernum = (marblenum-1) % n_players
        if marblenum % 23 != 0:
            cm = cm.next
            cm.insert_next(marblenum)
        else:
            scores[playernum] += marblenum
            for i in range(7):
                cm = cm.prev
            scores[playernum] += cm.val
            cm = cm.next
            cm.delete_prev()
    return max(scores)
            
print(game(9, 25))



