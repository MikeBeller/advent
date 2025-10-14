\l ../lib/prel.k

gs: each[split["\n"]] split["\n\n"] read "input.txt"
sum each[{len uniq join[""] x}] gs

/ part 2
num.all.yes:{sum len[x] = count join[""] x}
sum each[num.all.yes] gs

