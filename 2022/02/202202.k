i:{`s$'(x[0];x[2])}'0:"input.txt"
s:`R`P`S!1 2 3
t:`X`Y`Z!`R`P`S
w:`A`B`C!(`R`P`S!3 6 0;`R`P`S!0 3 6;`R`P`S!6 0 3)
+/{p:t[x[1]]; s[p]+w[x[0]][p]}'i
c:`A`B`C!(`X`Y`Z!`S`R`P;`X`Y`Z!`R`P`S;`X`Y`Z!`P`S`R)
+/{p:c[x[0]][x[1]]; s[p]+w[x[0]][p]}'i
