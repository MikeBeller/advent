import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ c -- ? | is c a digit }
[ $ '9 > \ '0 \> | ~]  d:

{ -- c | get a char and also copy it to c:}
[ ^ $ c: ] g:

{ -- num -- input a number}
[ 0 [ g;! d;!] [ c; '0 - \ 10 * + ] # ] n:

n;!

{ read numbers into array at address
  pointed to by a, with len stored
  in first cell }

'''

debug=True
input="321"

m = FalseMachine(code, debug=debug, input=input)
m.run()
print(m.get_output())
