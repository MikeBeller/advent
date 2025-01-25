\l ../lib/prelude.k
(rs;us):split["\n\n"] read "tinput.txt"
rules:int flip each[split["|"]] split["\n"] rs
updates:int each[split[","]] split["\n"] us
rules
updates
