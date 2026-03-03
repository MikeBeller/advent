(ms;cs):"\n\n"\1:"input.txt"
m:((" "=)_|)'+(-1_"\n"\ms)@\: 1+4*!9
c:{(0;-1;-1) + `I$ (" "\x)@1 3 5}' "\n"\cs 
run:{[m;c]; (n;fi;ti):c; f:m[fi]
  t:m[ti]; t:t,rev@((-n)#f); f:(-n)_f
  @[m;(fi;ti);:;(f;t)]} 
rev:{|x}; (*|)' m run/ c 
rev:{x}; (*|)' m run/ c 
