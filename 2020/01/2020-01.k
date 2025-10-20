\l ../lib/prel.k
inp:int lines "input.txt"
{prod x[;first where 2020 = sum x]} inp[til(#inp;#inp)]
{prod x[;first where 2020 = sum x]} inp[til(#inp;#inp;#inp)]
