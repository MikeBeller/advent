import sys
sys.path.append('../../misc/false_lang')

from false import FalseMachine

code = '''
{input a number}
[
  0
  [ ^ $ 47 - $ 1_ > \\ 10 \\> &]  {num dig isdig?}
    [ 48 - \\ 10 * + ] #
\\ ] d:

d;! .
'''

m = FalseMachine(code, input="321 ")
#m = FalseMachine(code, debug=True, input="321 ")
m.run()
print(m.get_output())
