#!/usr/bin/env python3
import sys, argparse, pathlib

def convert(path, start=0):
    data = pathlib.Path(path).read_bytes()
    pos = start * 1024
    out = []
    while pos + 1024 <= len(data):
        blk = data[pos:pos+1024]
        for i in range(16):
            line = blk[i*64:(i+1)*64].rstrip(b' \x00').decode('ascii', 'replace')
            out.append(line)
        pos += 1024
    sys.stdout.write("\n".join(out))
    print()


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("scr")
    p.add_argument("--start", type=int, default=0, help="screens to skip")
    a = p.parse_args()
    convert(a.scr, a.start)

