td = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
""".strip()
data = open("input.txt").read()

closer = {'(': ')', '[': ']', '{': '}', '<': '>'}
opens = set(closer.keys())


def parse_line(line):
    st = []
    for c in line:
        if c in opens:
            st.append(c)
        else:
            assert c in list(closer.values())
            if len(st) == 0 or c != closer[st[-1]]:
                return ('ERROR', c)
            else:
                st.pop()
    return ('OK', st)


char_score = {')': 3, ']': 57, '}': 1197, '>': 25137}


def part1(data):
    score = 0
    for line in data.splitlines():
        status, result = parse_line(line)
        if status == 'ERROR':
            score += char_score[result]
    return score


assert part1(td) == 26397
print("PART1:", part1(data))

close_score = {'(': 1, '[': 2, '{': 3, '<': 4}


def part2(data):
    scores = []
    for line in data.splitlines():
        status, st = parse_line(line)
        if status == 'OK':
            score = 0
            while st:
                c = st.pop()
                score = score * 5 + close_score[c]
            scores.append(score)
    scores.sort()
    return scores[len(scores)//2]


assert part2(td) == 288957
print("PART2:", part2(data))
