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
char_score = {')': 3, ']': 57, '}': 1197, '>': 25137}


def part1(data):
    score = 0
    for line in data.splitlines():
        st = []
        for c in line:
            if c in opens:
                st.append(c)
            else:
                assert c in list(closer.values())
                if len(st) == 0 or c != closer[st[-1]]:
                    #print(line, "bad at", c)
                    score += char_score[c]
                    break
                else:
                    st.pop()
    return score


assert part1(td) == 26397
print("PART1:", part1(data))

close_score = {'(': 1, '[': 2, '{': 3, '<': 4}


def part2(data):
    scores = []
    for line in data.splitlines():
        error = False
        st = []
        for c in line:
            if c in opens:
                st.append(c)
            else:
                if len(st) == 0 or c != closer[st[-1]]:
                    error = True
                    break
                else:
                    st.pop()
        if error:
            continue
        score = 0
        while st:
            c = st.pop()
            score = score * 5 + close_score[c]
        scores.append(score)
    scores.sort()
    print(scores)
    return scores[len(scores)//2]


assert part2(td) == 288957
print("PART2:", part2(data))
