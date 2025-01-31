\l ../lib/prelude.k
(rs;us):split["\n\n"] read "tinput.txt"
rulepairs:int flip each[split["|"]] split["\n"] rs
updates:int each[split[","]] split["\n"] us

rules:rulepairs[1] group rulepairs[0]
okpair:{~contains[rules[y]] x}
okrow:{[r] $[2>#r; 1; 2=#r; okpair[r[0];r[1]]; o[1_r] & (&/ eachright[*r; okpair; 1_r])]}
mid:{x@_:(#x)%2}
sum each[mid] each[okrow] #updates

badrows:each[{~:okrow[x]}] #updates
badrows
row:badrows[0]

inds:{s: ! (#x;(#x)-1); (+s)@&(s[1]>s[0])}
swap:{[r;i;j] (r[i];r[j]):(r[j];r[i]); r}
scanrow:{[r] r {[r;y] (i;j):y; :[okpair[r[i];r[j]]; r; swap[r;i;j]]}/inds[r]}

fixrow:{{~pp[okrow[x]]}{pp[scanrow[x]]}/x}
badrows[1]
/ fixrow[badrows[1]]
okrow[badrows[1]]
