import sys
import io

digits = "0123456789"
lcase = "abcdefghijklmnopqrstuvwxyz"


class FalseMachine:
  def __init__(self, code, debug=False, input=""):
    self.code = code
    self.debug = debug

    self.input = io.StringIO(input)
    self.ip = 0
    self.mem = [0] * 65536
    self.sp = 26
    self.outputs = []
    self.return_stack = []

  def push(self, x):
    self.mem[self.sp] = x
    self.sp += 1

  def pop(self, n=1):
    if n == 1:
      self.sp -= 1
      return self.mem[self.sp]
    sp = self.sp
    self.sp -= n
    return tuple(self.mem[sp - i - 1] for i in range(n))

  def out(self, v):
    self.outputs.append(str(v))

  def get_output(self):
    return "".join(self.outputs)

  def getc(self):
    return self.input.read(1)

  def dump(self):
    print(self.ip-1, self.code[self.ip-1], self.mem[26:self.sp], " ".join([
      f"{lcase[i]}:{self.mem[i]}" for i in range(26) if self.mem[i] != 0
    ]), end=" -- ")
    print(" ".join([f"{i}:{self.mem[i]}" for i in range(10000,65536) if self.mem[i] != 0]))

  def run(self):
    
      
    entry_level = len(self.return_stack)

    while self.ip < len(self.code):
      c = self.code[self.ip]
      self.ip += 1
      if c.isspace():
        continue
      if c == "'":
        cc = ord(self.code[self.ip])
        self.push(cc)
        self.ip += 1
        continue
      if c == '{':
        while self.code[self.ip] != '}':
          self.ip += 1
        self.ip += 1
        continue
          
      if self.debug:
        self.dump()

      # parse numbers
      if c in digits:
        n = int(c)
        while self.ip < len(self.code) and (c := self.code[self.ip]) in digits:
          n = 10 * n + int(c)
          self.ip += 1
        self.push(n)
        continue

      # parse lambdas
      elif c == '[':
        self.push(self.ip)
        # advance ip to end of lambda
        depth = 1
        while depth > 0:
          c = self.code[self.ip]
          self.ip += 1
          if c == ']':
            depth -= 1
          elif c == '[':
            depth += 1

      # control structures
      elif c == '!':
        self.return_stack.append(self.ip)
        self.ip = self.pop()
      elif c == '?':
        body, cond = self.pop(2)
        self.return_stack.append(self.ip)
        self.ip = cond
        self.run()
        if self.pop() != 0:
          self.ip = body
          self.run()
        self.ip = self.return_stack.pop()
      elif c == '#':
        # while.  x is addr of condition lambda, y is addr of body lambda
        body, cond = self.pop(2)
        # while True:
        self.return_stack.append(self.ip)
        for i in range(6):
          self.ip = cond
          self.run()
          if self.pop() == 0:
            break
          self.ip = body
          self.run()
        self.ip = self.return_stack.pop()
      elif c == ']':
        if len(self.return_stack) == entry_level:
          return
        self.ip = self.return_stack.pop()

      # variable access and stack manipulation
      elif c in lcase:
        self.push(lcase.index(c))
      elif c == ':':
        ad, vl = self.pop(2)
        self.mem[ad] = vl
      elif c == ';':
        self.push(self.mem[self.pop()])
      elif c == '$':
        self.push(self.mem[self.sp-1])
      elif c == '%':
        self.pop()
      elif c == '\\':
        self.mem[self.sp-1], self.mem[self.sp -
                        2] = self.mem[self.sp-2], self.mem[self.sp-1]
      elif c == '@':  # rot
        z, y, x = self.pop(3)
        self.push(y)
        self.push(z)
        self.push(x)
      elif c == 'P':
        self.push(self.mem[self.sp - self.pop()])

      # IO
      elif c == '.':
        self.out(self.pop())
      elif c == ',':
        self.out(chr(self.pop()))
      elif c == '^':
        ch = self.getc()
        cc = ord(ch) if ch else 0
        self.push(cc)

      # arithmetic / logic
      elif c == '_':
        self.push(-self.pop())
      elif c == '~':
        self.push(~self.pop())
      elif c in "+-*/&|?>=":
        y, x = self.pop(2)
        if c == '+':
          r = x + y
        elif c == '-':
          r = x - y
        elif c == '*':
          r = x * y
        elif c == '/':
          r = x // y
        elif c == '&':
          r = x & y
        elif c == '|':
          r = x | y
        elif c == '>':
          r = -1 if x > y else 0
        elif c == '=':
          r = -1 if x == y else 0
        self.push(r)

      elif c == '"':
        while (c := self.code[self.ip]) != '"':
          self.out(c)
          self.ip += 1
        self.ip += 1  # Skip the closing quote
        continue


def false(code, debug=False, input=None):
  machine = FalseMachine(code, debug=debug, input=input)
  machine.run()
  return machine.get_output()


def test():
  # variable access
  assert false("3a: 9b: b; a; - .") == "6"
  # integer division
  assert false("37 2 / .") == "18"
  # lambdas
  assert false("3 [ 2 * ] ! .") == "6"
  assert false("7 [3 [2*] ! ] ! * .") == "42"
  # if
  assert false('[3 4 >] ["should not print"] ?') == ""
  assert false('[4 3 >] ["should print"] ?') == "should print"
  # while loop
  assert false("3 a: [ a; ] [a; $. 1- a:] #") == "321"
  # factorial
  assert false(''' 5 1\\ [ $ 1=~ ] [ $ @ * \\ 1- ] # % . ''') == "120"
  # random memory access peek / poke
  assert false("10000 p:   33p;: 10000 ; .") == "33"
  # test character output
  assert false("48,") == "0"
  # test character input
  assert false("^.", input="0") == "48"
  assert false("^.", input="") == "0"
  # skips comments
  assert false("33 {floogle } .") == "33"
  


if __name__ == "__main__":
  test()
  #print("All tests passed")
  # if there is an argument, treat it as a filename and run the code in it
  # else start a repl to read code from, running each line as it is entered
  if len(sys.argv) > 1:
    with open(sys.argv[1]) as f:
      code = f.read()
      print(false(code, debug=True))
  else:
    # use a repl with history support
    import readline
    machine = FalseMachine("")
    while True:
      code = input("false> ")
      machine.code = code
      machine.ip = 0
      machine.run()
      print(machine.get_output())
      machine.dump()
      machine.outputs = []
