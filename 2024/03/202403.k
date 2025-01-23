znan:{x*~^x}
pp:{`0: `k[x]; x}
starts:{[n;h] n~(#n)#h}

in: 1:"input.txt"
nums:{znan `I$ ","\ * ")"\x}
+/ */' nums' 1_"mul("\in  / part1

on:1; sm:0
update:{[s] n:nums[4_s]; sm::sm + (2=#n)*on*n[0]*n[1]}
r: {[ss] 3<#ss}{[ss]
     $[starts["don't()";ss]; on::0
      starts["do()";ss]; on::1
      starts["mul(";ss]; update[ss]]
      1_ss}/ in
sm

/ verbose version

readlines:(0::)
read:(1::)
split:{x\ y}
int:{`I$x}
first:(*:)
each:{x'y}
eachleft:{[x;f;y] x f\: y}
eachright:{[x;f;y] x f/: y}
sum:(+/)
prod:(*/)
max:(|/)
min:(&/)
sort:{x[<x]}
flip:(+:)
group:(=:)
count:(#:)
filter:{[f;t] f#t}
keys:(!:)
vals:(.:)
pp:{`0:`k[x]; x}
znan:{(~^x) * x}
diff:{1_-':x}
del:{y_x} /remove xth item from y
til:(!:)
len:(#:)
any:(|/)
drop:{x_y}

in: read "input.txt"
nums:{znan int split[","] first split[")"] x}

sum each[prod] each[nums] drop[1] split["mul("] in


