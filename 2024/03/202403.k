in: "\n"/0:`tinput2.txt
si:4+ in _ss "mul("
ss:si _\: in
ncn:{(")"\x)[0]}' ss
nums:{0$' ","\x}
safenums:{ns:@[nums;x;:]; :[ns[0]; (); 1; ns[1]] }
sns:safenums' ncn
+/ */' sns@ &2=#:'sns /part1

isns: si ,' sns
isns
0 1 , ((in _ss "do()") ,' 1), ((in _ss "don't()") ,' 0)
\\