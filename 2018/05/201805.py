import sys

# highly inefficient but extremely concise solution
def main():
    d = sys.stdin.read().strip()
    
    replacements = [l + chr(ord(l)+32) for l in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"] + [chr(ord(l) + 32) + l for l in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    
    while True:
        e = len(d)
        for r in replacements:
            d = d.replace(r,"")
        if e == len(d):
            break

    print(len(d))

if __name__ == '__main__':
    main()

