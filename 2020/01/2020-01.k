\l ../lib/prel.k
inp:int lines "input.txt"
pairs:{a:til[(len x;len y)]; n:a[;where a[1] > a[0]]; (x[n[0]];y[n[1]])}
pr:pairs[inp;inp]
prod raze pr[;where 2020 = sum pr]

ps:+pr[;where 2020 > sum pr]
s:inp!inp
d:2020 - each[sum] ps
cs:take[{~^x}] s[d]
prod cs

/ shorter version
{*/ x[;* & 2020 = sum x]} @ inp @ til(#inp;#inp)
