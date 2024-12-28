import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ c -- ? | is c a digit }
[ $ '9 > \ '0 \> | ~]  d:

{ -- num | input a number}
[ 0 [ c; d;!]
  [c; '0 - \ 10 * + ^c: ] #
] n:

{ n -- bool | char code is whitespace }
[ $$$ 32= \ 10= | \9= | \13= |] w:

{ -- | skip whitespace }
[ [ c; w;! ] [ ^c: ] # ] k:

{ read a list of numbers til eof }
[
  10000 a: 0 i:
  ^c:
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
