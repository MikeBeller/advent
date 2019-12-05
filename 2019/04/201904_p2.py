
def int_to_digits(n):
    return [int(d) for d in str(n)]

def is_nondecreasing(digits):
    for i in range(5):
        if digits[i+1] < digits[i]:
            return False
    return True

def run_lengths(ns):
    lens = [1]
    for i in range(1, len(ns)):
        if ns[i] != ns[i-1]:
            lens.append(1)
        else:
            lens[-1] += 1
    return lens

def is_valid(pwd):
    digits = int_to_digits(pwd)
    if not is_nondecreasing(digits):
        return False
    lens = run_lengths(digits)
    return any(ln > 1 for ln in lens)

assert is_valid(111111)
assert not is_valid(223450)
assert not is_valid(123789)

def part_one(s, e):
    c = 0
    for n in range(s,e+1):
        if is_valid(n):
            c += 1
    return c

def is_valid2(pwd):
    digits = int_to_digits(pwd)
    if not is_nondecreasing(digits):
        return False
    lens = run_lengths(digits)
    return any(ln == 2 for ln in lens)

assert is_valid2(112233)
assert not is_valid2(123444)
assert is_valid2(111122)

def part_two(s, e):
    c = 0
    for n in range(s,e+1):
        if is_valid2(n):
            c += 1
    return c

def main():
    s,e = 136818, 685979
    print(part_one(s,e))
    print(part_two(s,e))

if __name__ == '__main__':
    main()
