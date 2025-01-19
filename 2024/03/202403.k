/ prelude
znan:{x*~^x}
int:(`I$)
split:{[sep;s] sep\s}
filter:{[f;xs] xs@& f' xs}
pp:{`0: `k[x]; x}
suffixes:{(!#x)_\: x}
isprefix:{[n;h] n~(#n)#h}

in: 1:"input.txt"
nums:{znan int split[","; split[")"; x][0]]}
+/ */' nums' 1_"mul("\in  / part1


ops:("mul("; "don't()"; "do()")
anyprefix:{[ps;ss] (ps @& ps isprefix\: ss; ss)}
cmds:filter[{1=#x[0]}; anyprefix[ops;]' suffixes[in]]
muls:{[on;sm;s] n:nums[4_s]; :[2~=#n; (on;sm); (on; sm + on*n[0]*n[1])]}
doit:{[x;y] (on;sm):x; (cl;s):y;
    :[cl[0]~"don't()"; (0;sm);  cl[0]~"do()"; (1;sm); muls[on;sm;s]]}

*1_ (1;0) doit/ cmds    / part2
