i:0:"input.txt"
h:{n:-2!#x; (n#x; n_x)}
s:{c:`i$x; :[c>90; c-96; 26+c-64]}
+/ {(a;b):h@x; s@*a@&~^b?a}'i 

gs:((-3!#i);3)#i 
gf:{[g];q:(53#0){x[ \ ?s'y]+:1; \ x}/g; (3=)?q}
gf@gs[0]

