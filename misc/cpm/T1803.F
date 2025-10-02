1300 constant max-polys
4 cells constant poly-size
100 constant bufsize

create polys max-polys poly-size * allot

create linebuf bufsize allot
0 value filehandle
0 value npolys
: poly ( n -- addr ) poly-size * polys + ;

: px1 ;
: py1 1 cell+ ;
: px2 2 cells + ;
: py2 3 cells + ;

\ #nn @ x1,x2 WxH
: scan-poly ( buf pi -- )
  poly-size * polys + >r
  char @ scan
  1 /string /number d>s
    r@ px1 !
  1 /string /number d>s
    r@ py1 !
  1 /string /number d>s
    r@ px1 @ + r@ px2 !
  1 /string /number d>s
    r@ py1 @ + r@ py2 !
  rdrop ;
    

: read-data ( -- )
  s" T1803.TXT" R/O open-file abort" open-file"
  to filehandle

  begin
    linebuf bufsize filehandle read-line abort" read-line"   \ nread eof(0)
  while
    linebuf swap type cr 
    linebuf npolys scan-poly
    npolys 1+ to npolys
  repeat ;
    
read-data 
npolys . cr


unused . cr

create grid 10000 allot
2variable total
create pbuf poly-size allot
pbuf constant x1
x1 cell+ constant y1
y1 cell+ constant x2
x2 cell+ constant y2

: blit ;
: count-overlap 1 ;

: part1 ( -- d )
  0. total 2@
  1000 0 do
    grid 10000 erase
    npolys 0 do
      i poly pbuf poly-size copy
      x1 @ . y1 @ . x2 @ . y2 @ . cr
\      y2 @ j <
\      y1 @ j 10 + >
\      or not if
\        y1 @ j max y1 !
\        y2 @ j 10 + min y2 !
\        blit
\      then
    loop
    count-overlap dup d. cr 
    s>d total 2@ d+ 2!
  10 +loop

  ;
  

