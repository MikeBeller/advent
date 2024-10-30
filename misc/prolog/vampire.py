def dig(n: int) -> list[int]:
    return [int(d) for d in reversed(str(n))]


def num(n: list[int]) -> int:
    return sum(d * (10 ** i) for i, d in enumerate(n))


def vampire(n: int) -> tuple[list[int], list[int]] | None:
    ds = dig(n)
    if len(ds) % 2 != 0:
        return False
    l2 = len(ds) // 2
