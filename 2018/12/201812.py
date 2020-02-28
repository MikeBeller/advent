from typing import Tuple, DefaultDict

def read_data(fpath: str) -> Tuple[str, DefaultDict[str,str]]:
    init = ""
    conv: DefaultDict[str,str] = DefaultDict(lambda: ".")
    for line in open(fpath):
        f = line.strip().split()
        if len(f) != 3:
            continue
        if f[0] == "initial":
            init = f[2]
            continue
        assert f[1] == "=>"
        conv[f[0]] = f[2]
    return (init, conv)

def p(x):
    print(x)
    return x
            
def run_sim(state: str, n: int, conv: DefaultDict[str,str]) -> str:
    s = ".." + state + ".."
    for si in range(n):
        print(s)
        s = ".." + "".join(
                #conv[s[i:i+5]] for i in range(len(s)-4)).rstrip('.') + ".."
                p(conv[p(s[i:i+5])]) for i in range(len(s)-4)).rstrip('.') + "...."
    return s[2:].rstrip('.')

init,conv = read_data("tinput.txt")
print(init, conv)
s = init
#for i in range(20):
#    s = run_sim(s, 1, conv)
r = run_sim(init, 2, conv)
print(r)

