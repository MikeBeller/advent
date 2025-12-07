from a import *
inp = [range(b,e+1) for b,e in
         [Parse("ii",line,sep="-") 
         for line in Rd("02.txt").split(",")]]

fake = lambda n: Match(r"^(.+)\1$", str(n))
print(sum(filter(fake, chain(*inp))))

fake2 = lambda n: Match(r"^(.+?)(\1)+$", str(n))
print(sum(filter(fake2, chain(*inp))))
