from sys import stdin

digits = "0123456789"
lcase = "abcdefghijklmnopqrstuvwxyz"


class FalseMachine:
    def __init__(self, code, debug=False):
        self.code = code
        self.debug = debug

        self.ip = 0
        self.stack = [None] * 26
        self.outputs = []
        self.return_stack = []

    def push(self, x):
        self.stack.append(x)

    def pop(self, n=1):
        if n == 1:
            return self.stack.pop()
        return tuple([self.stack.pop() for _ in range(n)])

    def out(self, v):
        self.outputs.append(str(v))

    def dump(self, code, lcase):
        print(self.ip, code[self.ip], self.stack[26:], " ".join([
            f"{lcase[i]}:{self.stack[i]}" for i in range(26) if self.stack[i] is not None
        ]))

    def run(self):
        digits = "0123456789"
        lcase = "abcdefghijklmnopqrstuvwxyz"

        while self.ip < len(self.code):
            c = self.code[self.ip]
            self.ip += 1
            if self.debug and not c.isspace():
                self.dump(self.code, lcase)

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
                self.return_stack.append(self.ip)
                self.ip = self.pop() if self.pop() == 0 else self.ip
            elif c == '#':
                # while.  x is addr of condition lambda, y is addr of body lambda
                # &&&
                cond, body = self.pop(2)
                self.return_stack.append(self.ip)
                self.ip = cond
                self.ip = self.pop() if self.pop() == 0 else self.ip
            elif c == ']':
                self.ip = self.return_stack.pop()
            elif c in lcase:
                self.push(lcase.index(c))
            elif c == ':':
                ad, vl = self.pop(2)
                self.stack[ad] = vl
            elif c == ';':
                self.push(self.stack[self.pop()])
            elif c == '.':
                self.out(self.pop())
            elif c == '_':
                self.push(-self.pop())
            elif c == '~':
                self.push(~self.pop())
            elif c in "+-*/&|":
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
                    r = x > y
                elif c == '=':
                    r = x == y
                self.push(r)
            elif c == '"':
                while (c := self.code[self.ip]) != '"':
                    self.out(c)
                    self.ip += 1
                self.ip += 1  # Skip the closing quote
                continue
            elif c == '$':
                self.push(self.stack[-1])
            elif c == '%':
                self.pop()
            elif c == '\\':
                self.stack[-1], self.stack[-2] = self.stack[-2], self.stack[-1]
            elif c == '@':  # rot
                z, y, x = self.pop(3)
                self.push(y)
                self.push(z)
                self.push(x)
            elif c == 'P':
                self.push(self.stack[-self.pop()])

        r = "".join(self.outputs)
        if self.debug:
            print("result", r)
        return r


def false(code, debug=False):
    machine = FalseMachine(code, debug=debug)
    return machine.run()


def test():
    assert false("3a: 9b: b; a; - .") == "6"
    assert false("37 2 / .") == "18"
    assert false("3 [ 2 * ] ! .") == "6"
    assert false("7 [3 [2*] ! ] ! * .") == "42"

    # assert false('''
    # 5
    # 1\\
    #   [ $ 1=~ ]
    #     [ $ @ * \\ 1- ]
    #   # % .

    # ''', debug=True) == "120"


if __name__ == "__main__":
    test()
    # code = stdin.read()
    # print(false(code))
