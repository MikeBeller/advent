import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ c -- ? | is c a digit }
[ $ '9 > \ '0 \> | ~]  d:

{ -- c | get a char and also copy it to c:}
[ ^ $ c: ] g:

{ -- num -- input a number}
[ 0 [ g;! d;!]
  [c; '0 - \ 10 * + ] #
] n:
 
[
  10000 a: 0 i:
  1_ c:
  [ c; ] [
    n;!
    i;1+i: a;i;+ : ] #
] r:

r;!

'''

debug=True
input="23 54 79"

m = FalseMachine(code, debug=debug, input=input)
m.run()
print(m.get_output())
