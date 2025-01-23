in:{`I$' " "\x}' 0:"input.txt"

 / part1
valid:{d:1_-':x; mn:&/d; mx:|/d;
  ((mn>0)&(mx<4)) | ((mx<0)&(mn>-4))}
+/valid'in 

/ part2
anyvalid:{[a] |/ {valid[x _ y]}[a;]'!#a}
+/ anyvalid'in

/ verbose version

readlines:(0::)
split:{x\ y}
int:{`I$x}
first:(*:)
each:{x'y}
eachleft:{[x;f;y] x f\: y}
eachright:{[x;f;y] x f/: y}
sum:(+/)
max:(|/)
min:(&/)
sort:{x[<x]}
flip:(+:)
group:(=:)
count:(#:)
filter:{[f;t] f#t}
keys:(!:)
vals:(.:)
pp:{`0:`k@x}
znan:{(~^x) * x}
diff:{1_-':x}
del:{y_x} /remove xth item from y
til:(!:)
len:(#:)
any:(|/)

in: each[{int split[" "] x}] readlines "input.txt"

/part1
valid:{[x] d:diff[x]; mn:min[d]; mx: max[d]
   ((mn>0)&(mx<4)) | ((mx<0)&(mn>-4))}
sum each[valid] in

/part2
drops:{[a] eachleft[(til len a); {del[x; y]}; a]}
anyvalid:{any each[valid] drops x}
sum each[anyvalid] in
