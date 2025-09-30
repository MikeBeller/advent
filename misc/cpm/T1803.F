1500 constant max-polys
4 cells constant poly-size
128 constant bufsize

create polys max-polys poly-size * allot

create buffer bufsize allot
0 value filehandle

: read-data ( -- )
  s" T1803.TXT" R/O open-file abort" open-file"
  to filehandle

  begin
    buffer bufsize filehandle read-line abort" read-line"   \ nread eof(0)
  while
    buffer swap type cr 
  repeat ;
    
read-data 

bye 
