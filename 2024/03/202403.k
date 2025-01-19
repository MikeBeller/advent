in: "\n"/ 0:"tinput.txt"
suffixes:{(!#x)_\: x}
startswith:{y~x#(#y)}
mul:{sw[x;"mul("]}

\\
si:4+ in _ss "mul("
ss:si _\: in
nns:","\' {(")"\x)[0]}' ss
isdec:{~ |/ 10="0123456789"?/:x}
safenum:{:[((0<#x)&(4>#x)&isdec[x]); 0$x ; 0]}
mul:{:[~2=#x; 0; safenum[x[0]] * safenum[x[1]]]}
muls: mul' nns
+/ muls     /part1

onoff:(,(0;1)), ((in _ss "don't()"),\: 0), ((in _ss "do()"),\: 1)
dd:+ onoff[<onoff@'0]
bs:-1 + dd[0] _binl si
+/ dd[1][bs] * muls   / part2
\\
