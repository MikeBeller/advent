in: "\n"/ 0:"input.txt"
znan:{x*~^x}
nums:{znan `I$ ","\ (")"\x)[0]}
+/ */' nums' 1_"mul("\in

filter:{[f;xs] xs@& f' xs}
suffixes:{(!#x)_\: x}
isprefix:{[n;h] n~(#n)#h}
ops:("mul("; "don't()"; "do()")
anyprefix:{[ps;ss] (ps @& ps isprefix\: ss; ss)}
cmds:filter[{1=#x[0]}; anyprefix[ops;]' suffixes[in]]
#cmds
