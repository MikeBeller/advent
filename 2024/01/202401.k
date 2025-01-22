(a;b):+ `I$' "   "\' 0:"input.txt"
abs:{x|-x}
+/ abs a[<a] - b[<b]

/part 2
c: #'=b
+/ a * c[a] * ~0N=c[a]

/ verbose version -- here is a prelude
readlines:(0::)
split:{x\ y}
int:{`I$x}
first:(*:)
each:{x'y}
sum:(+/)
sort:{x[<x]}
flip:(+:)
group:(=:)
count:(#:)
filter:{[f;t] f#t}
keys:(!:)
vals:(.:)
pp:(`k@)
znan:{(~^x) * x}

/ and here is the code -- seriously more readable
(a;b): flip int each[split["   "]]  readlines "input.txt"
sum abs (sort a) - (sort b)

c:each[count] group b
sum znan a * c[a]

