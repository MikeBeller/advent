import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ -- num | input a number}
[ 0 [ c;  $ '9 > \ '0 \> | ~ ]
  [c; '0 - \ 10 * + ^c: ] # ] n:

{ -- | skip whitespace }
[ [ c; $$$ 32= \ 10= | \9= | \13= | ] [ ^c: ] # ] w:

{ read two columns of numbers}
1000 a: 3000 b: 0 i:
^c:
[ w;! c; ] [
  n;! a;i;+ :
  w;! n;! b;i;+ :
  i;1+i: ] #


{arr ln --  | bubble sort array arr of length ln}
[
 l: x: 1y:
 [ y; ] [
   0y: 0j:
   [ j; l;1- < ] [
     x;j;+ $ p: 1+ q:
     p;; q;; >  [
       p;; q;; p;: q;: 
       y;1+y:
     ] ?
     j;1+j:
   ] #
 ] #
] s:

a; i; s;!
b; i; s;!

{add up differences}
0j: 0t:
[j; i; <] [
  a;j;+; b;j;+; -
  $ 0 < [_] ?
  t; + t:
  j;1+j:
] # t;. 10,
'''

debug=False
live_output=False
input=open("input.txt").read()

m = FalseMachine(code, debug=debug, input=input, live_output=live_output)
m.run()
print(m.get_output())
