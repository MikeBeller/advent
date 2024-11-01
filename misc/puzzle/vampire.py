from itertools import permutations


def dig(n: int) -> list[int]:
    return [int(d) for d in reversed(str(n))]


def num(n: list[int]) -> int:
    return sum(d * (10 ** i) for i, d in enumerate(n))


def vampire(n: int) -> tuple[int, int, int] | None:
    ds = dig(n)
    if len(ds) % 2 != 0:
        return False
    l2 = len(ds) // 2
    lf = ds[:l2]
    rt = ds[l2:]
    pr = num(lf) * num(rt)
    if list(sorted(dig(pr))) == list(sorted(lf + rt)) and not (lf[0] == 0 and rt[0] == 0):
        return pr, num(lf), num(rt)
    return None


def vampires(ndig: int) -> list[tuple[int, int, int]]:
    vs = set()
    for i in range(10**(ndig-1), 10**(ndig)):
        if (v := vampire(i)):
            pr, lf, rt = v
            if lf > rt:
                lf, rt = rt, lf
            vs.add((pr, lf, rt))
    return vs


vs = vampires(6)
# print(len(vs), vs)
print(len(set(vn for vn, _, _ in vs)))
