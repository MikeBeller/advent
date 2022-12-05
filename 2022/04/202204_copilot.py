
def parse(instr):
    """
    Parse the input into a list of lines, then convert each
    line to a tuple of 2 tuples
    Each line has format "aa-bb,cc-dd" and should
    be converted to ((aa,bb), (cc,dd))
    """
    lines = instr.splitlines()
    return [tuple(tuple(int(x) for x in line.split('-')) for line in line.split(',')) for line in lines]

# parse the contents of the file "tinput.txt" and store the result in "tinput"
with open('tinput.txt') as f:
    tinput = parse(f.read())

# parse the contents of the file "input.txt" and store the result in "input"
with open('input.txt') as f:
    input = parse(f.read())

def part1(commands):
    """
    For each command, count the cases where the range represented by the second
    tuple in the command is fully contained in the range represented by the
    first tuple in the command, plus the count of cases where the range
    represented by the first tuple in the command is fully contained in the
    range represented by the second tuple in the command.
    Return the total count.
    """
    return sum(
        1 if t1[0] <= t2[0] <= t2[1] <= t1[1] else
        1 if t2[0] <= t1[0] <= t1[1] <= t2[1] else
        0
        for t1, t2 in commands)

# confirm that part1(tinput) returns 2
assert part1(tinput) == 2

# print the result of part1(input)
print(part1(input))

def part2(commands):
    """
    For each command, count the cases where there is any overlap between the
    ranges represented by the two tuples in the command."""
    return sum(
        1 if t1[0] <= t2[0] <= t1[1] or t2[0] <= t1[0] <= t2[1] else
        0
        for t1, t2 in commands)

# confirm that part2(tinput) returns 4
assert part2(tinput) == 4

# print the result of part2(input)
print(part2(input))


