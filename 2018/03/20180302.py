import sys
import numpy as np

def get_data():
    r = []
    for line in open("input.txt"):
        f = line.strip().split()
        iid = int(f[0][1:])
        l,t = [int(x) for x in f[2].replace(':','').split(",")]
        w,h = [int(x) for x in f[3].split('x')]
        r.append(dict(iid=iid, left=l, top=t, width=w, height=h))
    return r

def blit(a, l, t, w, h):
    a[l:(l+w),t:(t+h)] += 1

def check(a, l, t, w, h):
    return (a[l:(l+w),t:(t+h)] == 1).all()

def main():
    data = get_data()
    max_x = max(d['left'] + d['width'] for d in data)
    max_y = max(d['top'] + d['height'] for d in data)
    a = np.zeros((max_x+1,max_y+1),dtype=np.int32)
    for d in data:
        blit(a, d['left'], d['top'], d['width'], d['height'])
    for d in data:
        if check(a, d['left'], d['top'], d['width'], d['height']):
            print(d['iid'])

if __name__ == '__main__':
    main()

