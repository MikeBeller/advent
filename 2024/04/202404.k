\l ../lib/prelude.k

in: readlines "input.txt"
nr:#in
nc:#in[0]

next:((0;1); (1;1); (1;0); (1;-1); (0;-1); (-1;-1); (-1;0); (-1;1))
path:{[r;c;d] repeats[3; {[d;rc] rc+next[d]}[d]; (r;c)]}
follow:{eachright[in; (.); x]}
xmas:{[r;c;d] "XMAS"~follow[path[r;c;d]]}
sweep:{[r;c] each[xmas[r;c]] (til 8)}
sum sum each[{(sweep.)x}; cross[til nr; til nc] ]


