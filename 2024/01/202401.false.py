import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ c -- ? | is c a digit }
[ $ '9 > \ '0 \> | ~]  d:

{ -- c | get a char and also copy it to c:}
[ ^ $ c: ] g:

{ -- num | input a number}
[ 0 [ g;! d;!]
  [c; '0 - \ 10 * + ] #
] n:

{ n -- bool | char code is whitespace }
[ $$$ 32= \ 10= | \9= | \13= |] w:

{ -- | skip whitespace }
[ [ c; w;! ] [ g;! ] # % ] k:

{ read a list of numbers til eof }
[
  k;!
  10000 a: 0 i:
  [ c; ] [
    k;!
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
