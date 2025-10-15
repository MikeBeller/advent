\l ../lib/prel.k
i: lines "input.txt"
bits: each[{("B"=take[7] x;"R"=drop[7] x)}] i
seatno:{(r;c):x; ((2/ r)*8) + (2/ c)}
sns: each[seatno] bits

max sns
-1 + first takewhere[{ (2=)  eachprior[(-)] x}] asc sns


