m = open("07.txt").read().splitlines()
nr = len(m)
nc = len(m[0])
sc = m[0].index("S")
beams = {sc}
nsplits = 0
for r in range(1,nr):
    new_beams = set()
    for c in beams:
        if m[r][c] == "^":
            new_beams |= {c-1, c+1}
            nsplits += 1
        else:
            new_beams |= {c}
    beams = new_beams

print(nsplits)
