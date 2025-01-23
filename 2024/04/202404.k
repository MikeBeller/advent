\l ../lib/prelude.k

in: readlines "tinput.txt"
nr:#in
nc:#in[0]

next:((0;1); (1;1); (1;0); (1;-1); (0;-1); (-1;-1); (-1;0); (-1;1))
path:{[r;c;d] repeats[3; {[d;rc] rc+next[d]}[d]; (r;c)]}
follow:{eachright[in; (.); x]}
xmas:{[r;c;d] "XMAS"~follow[path[r;c;d]]}

/ sum xmas[r;c;d] for r in range(nr) for c in range(nc) for d in range(8)

