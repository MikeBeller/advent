in: `I$' " "\'0:"input.txt"
diff:{1_ -':x}
valid:{ d:diff[x]; mn:&/d; mx:|/d; ((mn>0)&(mx<4)) | ((mx<0)&(mn>-4))}
+/valid'in

\\
