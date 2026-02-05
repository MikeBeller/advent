i:`I$' (,"-")\' (,",")\ *0:"02.txt"
dub:{s:$x; n:#s; n2:-2!n
  (0=2!n) & (n2#s) ~ (n2_s) }
seq:{(a;b):x;a+!b-a+1}
/ +/ ,/ {(dub')#seq@x}'i
chop:{((-x)!#y; x) # y}
rep:{(0=x!#y) & (&/ (1_~': chop[x;y]))}
reps:{s:$x; n:#s; n2:_(0.6)+n%2
   |/ rep[;s]' 1+!n2}
+/ ,/ {(reps')#seq@x}'i
