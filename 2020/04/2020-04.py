inp=[
  {k:v for k,v in
    [ pr.split(":")
        for pr in doc.strip().split()]}
    for doc in open("input.txt").read().split("\n\n")]

print(inp)

