/verbose version (ngn/k)
abs:{x|-x}
lines:{0:x}
split:{x\y}
each:{x'y}
int:{`I$x}
sort:{x[<x]}
sum:{+/x}
flip:(+)
count:{#'=x}

/part1
/ (a;b): flip each[int] each[split["   "]] lines["input.txt"]
(a;b): + int' split["   "]' lines["input.txt"]
sum abs sort[a] - sort[b]

/part2
c:count b
sum a * c[a]
\\

