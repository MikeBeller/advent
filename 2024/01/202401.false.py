import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = r'''
{ -- chr num -- input a number}
[
  0
  [ ^ $$ '9 > \ '0 \> | ~]  {num dig isdig?}
    [ '0 - \ 10 * + ] #
\ ] d:

d;! .


'''

debug=True
input="321"

m = FalseMachine(code, debug=debug, input=input)
m.run()
print(m.get_output())
