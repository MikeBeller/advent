\l ../lib/prelude.k
(rs;us):split["\n\n"] read "input.txt"
rulepairs:int flip each[split["|"]] split["\n"] rs
updates:int each[split[","]] split["\n"] us
rules:rulepairs[1] group rulepairs[0]
okpair:{~contains[rules[y]] x}
okrow:{[r] $[2>#r; 1; 2=#r; okpair[r[0];r[1]]; o[1_r] & (&/ eachright[*r; okpair; 1_r])]}
mid:{x@_:(#x)%2}
sum each[mid] (each[okrow] #updates)
