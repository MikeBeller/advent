\l ../lib/prelude.k

inp: readlines "input.txt"
nr:#inp
nc:#inp[0]

next:((0;1); (1;1); (1;0); (1;-1); (0;-1); (-1;-1); (-1;0); (-1;1))
path:{[r;c;d] repeats[3; {[d;rc] rc+next[d]}[d]; (r;c)]}
trace:{eachright[inp; (.); x]}
xmas:{[r;c;d] "XMAS"~trace[path[r;c;d]]}
sweep:{[r;c] each[xmas[r;c]] (til 8)}
sum sum each[{(sweep.)x}; cross[til nr; til nc] ]

xpath:(0 0; -1 -1; 1 1; -1 1; 1 -1)
vld:("AMSMS"; "ASMSM"; "AMSSM"; "ASMMS")
ismas:{contains[vld;] trace[eachright[x;(+)] xpath]}
sum each[{ismas[x]}; cross[til nr; til nc] ]
