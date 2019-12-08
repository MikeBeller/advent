import numpy as np

llen = 25*6
buf = np.frombuffer(open("input.txt","rb").read().strip(), dtype=np.uint8) - 48
layers = buf.reshape((len(buf)//llen, llen))

# part one
counts = np.apply_along_axis(np.bincount, 1, layers)
r = min(counts, key=lambda t: t[0])
print(r[1] * r[2])

# part two
inds = np.argmax(layers != 2, axis=0)
img = layers[inds,np.arange(llen)].reshape((6,25))
for i in range(6):
    r = img[i,:]
    print("".join(("@" if n == 1 else " ") for n in r))

