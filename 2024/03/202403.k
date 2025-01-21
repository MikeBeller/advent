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
