in: "\n"/0:`input.txt
si:4+ in _ss "mul("
ss:si _\: in
ncn:{(")"\x)[0]}' ss
nums:{0$' ","\x}
safenums:{ns:@[nums;x;:]; :[ns[0]; (); 1; ns[1]] }
sn:safenums' ncn
+/ */' sn@ &2=#:'sn

\\