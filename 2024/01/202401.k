(a;b):+ `I$' "   "\' 0:"input.txt"
abs:{x|-x}
+/ abs a[<a] - b[<b]

/part 2
c: #'=b
+/ a * c[a] * ~0N=c[a]


read0:(0::)
split:{x\ y}
int:{`I$x}
first:(*:)
each:{x'y}
sum:(+/)
sort:{x[<x]}
flip:(+:)

(a;b): flip int each[split["   "]]  read0 "tinput.txt"
sum abs (sort a) - (sort b)
