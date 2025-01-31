\l ../lib/prelude.k
(rs;us):split["\n\n"] read "tinput.txt"
rulepairs:int flip each[split["|"]] split["\n"] rs
updates:int each[split[","]] split["\n"] us
rules:rulepairs[1] group rulepairs[0]

mid:{x@_:(#x)%2}
allpairs:{s: ! (#x;(#x)); (+s)@&(s[1]>s[0])}
okpair:{~contains[rules[y]] x}
okrow:{[r] &/ okpair.' r@ allpairs[r]}
+/ mid' (okrow')# updates

badrows:(~okrow')#updates
badrows
swap:{[r;i;j] (r[i];r[j]):(r[j];r[i]); r}
scanrow:{[r] r {[r;y] (i;j):y
  :[okpair[r[i];r[j]]; r; swap[r;i;j]]}/inds[r]}

fixrow:{{okrow[x]}{scanrow[x]}/x}
+/ mid' fixrow'badrows
