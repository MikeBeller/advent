i:("III";",") 0: read0 `08t.txt
w:(til count i) cross (til count i)
ps: flip w[where {x[0]<x[1]} each w]
ai:ps[0]
bi:ps[1]

as:i[ai]; bs:i[bi]
d: sqrt each sum {{x*x}[(flip as)[x]-(flip bs)[x]]} each til 3
di: iasc d

f:{
  a:cs[ai[x]];
  b:cs[bi[x]];
  if[a>b; @[`cs;where cs=a;::;b];
     a<b; @[`cs;where cs=b;::;a];
     1]}

cs:til count i
f each di
show cs
show desc value group cs
