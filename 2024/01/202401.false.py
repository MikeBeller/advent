import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ c -- ? | is c a digit }
[ $ '9 > \ '0 \> | ~]  d:

{ -- num | input a number}
[ 0 [ c; d;!]
  [c; '0 - \ 10 * + ^c: ] # ] n:

{ n -- bool | char code is whitespace }
[ $$$ 32= \ 10= | \9= | \13= |] w:

{ -- | skip whitespace }
[ [ c; w;! ] [ ^c: ] # ] k:

{ read two columns of numbers into arrays a and b }
[
  1000 a: 3000 b: 0 i:
  ^c:
  [ c; ] [
    k;! n;! a;i;+ :
    k;! n;! b;i;+ :
    i;1+i: ] #
] r:

r;!

{arr ln --  | bubble sort array arr of length ln}
[
 l: x: 1y:
 [ y; ] [
   0y: 0j:
   [ j; l;1- \> ] [
     x;j;+; x;j;+1+; >  [
       x;j;+; x;j;+1+;
       x;j;+: x;j;+1+:
       y;1+y:
     ] ?
     j;1+j:
   ] #
 ] #
] s:

D
a; i; s; !
b; i; s; !
D

'''

debug=True
debug=False

input=open("tinput.txt").read()

m = FalseMachine(code, debug=debug, input=input)
m.run()
print(m.get_output())
