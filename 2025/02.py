from a import *
inp = [range(*[int(s) for s in p.split("-")])
       for p in Rd("02.txt").split(",")]

fake = lambda n: Match(r"^(.+)\1$", str(n))

assert not fake(101)
assert fake(6464)

print(sum(filter(fake, chain(*inp))))

fake = lambda n: Match(r"^(.+)(\1)+$", str(n))
print(sum(filter(fake, chain(*inp))))