in: "\n"/0:`tinput2.txt
si:4+ in _ss "mul("
ss:si _\: in
ncn:{(")"\x)[0]}' ss
nums:{0$' ","\x}
safenums:{ns:@[nums;x;:]; :[ns[0]; (); 1; ns[1]] }
sns:safenums' ncn
+/ */' sns@ &2=#:'sns /part1

isns: si ,' `mul ,' sns
dds: ,/ (,(0;`do) ; ((in _ss "do()") ,' `do) ; ((in _ss "don't()") ,' `dont))
all:(isns,dds)
all:all[<all@'0]
0 {:[`do=y[1];d:1;
     `dont=y[1];d:0;
     1; x+y[2]*y[3]]}' all
\\