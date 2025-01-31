/ compute collatz steps in parallel for all numbers. weed out 1's each step
cp:{w:0=2!x; (w * (-2!x)) + ((~w) * (1+3*x))}
\t ans: #: {0<#x}{n:cp[x]; (1=)_n}\(2+!999998)
ans
