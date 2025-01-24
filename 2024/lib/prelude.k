find:{[needle;haystack] & (#needle) (needle~)': haystack}
readlines:(0::)
read:(1::)
split:{x\ y}
int:{`I$x}
first:(*:)
each:{x'y}
eachleft:{[x;f;y] x f\: y}
eachright:{[x;f;y] x f/: y}
sum:(+/)
prod:(*/)
max:(|/)
min:(&/)
sort:{x[<x]}
uniq:(?:)
flip:(+:)
group:(=:)
count:(#:)
filter:{[f;t] f#t}
keys:(!:)
vals:(.:)
pp:{`0:`k[x]; x}
znan:{(~^x) * x}
diff:{1_-':x}
del:{y_x} /remove xth item from y
til:(!:)
len:(#:)
any:(|/)
drop:{x_y}
while:{[t;b;x] t b/x}
repeat:{[n;b;x] n b/x}
repeats:{[n;b;x] n b\x}
raze:(,/)
cross:{raze x,/:\:y}
