in:(-48+`i$)' 0:"03.txt"
odo:{[n] m:!(n;n); m[;&m[1]>m[0]]}
bmx:{[i] |/ {x[1]+10*x[0]}'+i[odo@#i]}
:p1:+/ bmx' in


