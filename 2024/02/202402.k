in:{`I$' " "\x}' 0:"input.txt"

 / part1
valid:{d:1_-':x; mn:&/d; mx:|/d;
  ((mn>0)&(mx<4)) | ((mx<0)&(mn>-4))}
+/valid'in 

/ part2
anyvalid:{[a] |/ {valid[x _ y]}[a;]'!#a}
+/ anyvalid'in
\\

