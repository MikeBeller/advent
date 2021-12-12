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
