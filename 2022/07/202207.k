i:{(*x;1_x)}' 1_ "\n"\' "\n$ "\ 1:"input.txt"
ed:{(0#`)!()}
d:(,`r)!,ed[]
p:,`r
ls:{(c;v):" "\x
  r: :["dir"~c;ed[];`I$c]
  .[`d;p,`$v;:;r]}
cd:{:[".."~x; p::-1_p; p::p,`$x]}
zzz:{(c;r):x
  :["ls"~c
    ls' r
    cd[(" "\ c)[1]]]}' i
ds:!0
f:{:[`i=@x;x;[t:+/f'x;ds::ds,t;t]]};
tot:f@d
+/ ds@&(ds<100000)
need:tot-(70000000-30000000)
&/ (need<)#ds

