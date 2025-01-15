in:{0$' " "\x}' 0:"input.txt"

diff:{-':x}
valid:{ d:diff[x]; mn:&/d; mx:|/d; ((mn>0)&(mx<4)) | ((mx<0)&(mn>-4))}
+/valid'in      / part 1
a:in[0]
2 _ a
\\
|/ {valid[x_y]}[a;]'!#a
\\
anyvalid:{[a] |/ {valid[x_y]}[a;]'!#a}
+/ anyvalid'in  / part 2
\\

