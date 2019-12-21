import math
import numpy as np

test1 = b'12345678'

def digs(digstr):
    return (np.frombuffer(digstr, dtype=np.uint8) - 48).astype(np.int32)

def fft_mat(digstr, nphase):
    ds = digs(digstr)
    n = len(ds)
    a = np.zeros((n,n), dtype=np.int32)
    for i in range(1,n+1):
        ln = (4 * i) - 1
        mpy = int(math.ceil(n/ln))
        a[i-1,:] = np.tile(np.repeat([0,1,0,-1], [i,i,i,i]), mpy)[1:n+1]
    for i in range(nphase):
        ds = np.dot(a,ds)
        ds = np.abs(ds)
        ds = ds % 10
    return ds

def fft_vec(digstr, nphase):
    ds = digs(digstr)
    n = len(ds)
    ds2 = np.zeros(n, dtype=np.int32)
    for ph in range(nphase):
        print("PHASE:", ph)
        for i in range(1,n+1):
            ln = (4 * i) - 1
            mpy = int(math.ceil(n/ln))
            a = np.tile(np.repeat([0,1,0,-1], [i,i,i,i]), mpy)[1:n+1]
            ds2[i-1] = np.dot(a,ds)
            ds2 = np.abs(ds2)
            ds2 %= 10
        ds[:] = ds2
    return ds

def fft_sub(digstr, reps, nphase):
    ds = digs(digstr)
    n = len(ds)
    for ph in range(nphase):
        for di in range(digstr):
            lcm = np.lcm(n, di)

fft = fft_mat
assert np.all(fft(b'12345678', 4) == digs(b'01029498'))
assert np.all(fft(b'80871224585914546619083218645595',100)[:8] == digs(b'24176176'))
assert np.all(fft(b'19617804207202209144916044189917',100)[:8] == digs(b'73745418'))
assert np.all(fft(b'69317163492948606335995924319873',100)[:8] == digs(b'52432133'))

def main():
    instr = open("input.txt","rb").read().strip()
    ans1 = fft(instr, 100)
    print(ans1[:8])

    #ans2 = fft(instr*10000, 100)
    #with open("ans2.out","w") as outfile:
    #    print(ans2, file=outfile)

main()

