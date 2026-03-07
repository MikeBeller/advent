i:{(*x;1_x)}' 1_ "\n"\' "\n$ "\ 1:"input.txt"
ed:{(0#`)!()}
d:(,`r)!,ed[]
p:,`r
ls:{(c;v):" "\x
  r: :["dir"~c;ed[];`I$c]
    / (d;p;c;v)
  .[`d;p,`$v;:;r]}
cd:{:[".."~x; p::-1_p; p::p,`$x]}
zzz:{(c;r):x
  :["ls"~c
    ls' r
    cd[(" "\ c)[1]]]}' i

