i:("III";",") 0: read0 `08.txt
nr:count i[0]
w:(til nr) cross (til nr)
ps: flip w[where {x[0]<x[1]} each w]
ai:ps[0]
bi:ps[1]

as:i[;ai]; bs:i[;bi]
d: sqrt sum {sms:"f"$as[x]-bs[x]; sms*sms} each til 3
di: iasc d

f:{
  a:cs[ai[x]]; b:cs[bi[x]];
  if[a>b; `cs set @[cs;where cs=a;:;b]];
  if[a<b; `cs set @[cs;where cs=b;:;a]]}

cs:til nr
zzz:f each 1000 # di
show prd 3# desc value count each group cs / part1

cs:til nr; j:0
while[not all 0=cs; f[di[j]]; j::j+1]
show as[0;di[j-1]] * bs[0;di[j-1]] / part2
\\
