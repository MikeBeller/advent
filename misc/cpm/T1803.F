system

include ttester.f

1300 constant max-polys
4 cells constant poly-size
100 constant bufsize

create polys max-polys poly-size * allot

application

create linebuf bufsize allot
0 value filehandle
0 value npolys
: poly ( n -- addr ) poly-size * polys + ;  \ address of nth poly in array

: px1 ;
: py1 cell+ ;
: px2 2 cells + ;
: py2 3 cells + ;

0 value x1 
0 value y1 
0 value x2 
0 value y2

\ #nn @ x1,x2 WxH
: scan-poly ( addr n  -- x1 y1 x2 y2 )
  [char] @ scan
  2 /string /number d>s to x1
  1 /string /number d>s to y1
  1 /string /number d>s x1 + to x2
  1 /string /number d>s y1 + to y2
  2drop
  x1 y1 x2 y2
  ;

T{  s" #12 @ 345,678 77,88"  scan-poly -> 345 678 422 766 }T

: save-poly ( x1 y1 x2 y2 addr -- )
  >r 
  r@ py2 !
  r@ px2 !
  r@ py1 !
  r> px1 !
;

: get-poly ( addr - x1 y1 x2 y2 )
  >r
  r@ px1 @
  r@ py1 @
  r@ px2 @
  r> py2 @
  ;

T{ 345 678 422 766 polys save-poly polys get-poly -> 345 678 422 766 }T


: read-data ( -- )
  s" T1803.TXT" R/O open-file abort" open-file"
  to filehandle

  begin
    linebuf bufsize filehandle read-line abort" read-line"   \ nread eof(0)
  while
    linebuf swap 2dup type cr 
    scan-poly   \ x1 y1 x2 y2
    npolys poly save-poly
    npolys 1+ to npolys
  repeat ;
    
read-data 
npolys . cr

bye

fyi cr
application

create grid 10000 allot
2variable total
create pbuf poly-size allot
pbuf constant x1
x1 cell+ constant y1
y1 cell+ constant x2
x2 cell+ constant y2

: blit ;
: count-overlap 1 ;


fyi

pbuf . x1 . y2 . cr


: part1 ( -- d )
  0. total 2@
\  1000 0 do
  1 0 do
    grid 10000 erase
    npolys 0 do
      i poly pbuf poly-size move
      x1 @ . y1 @ . x2 @ . y2 @ . cr
\      y2 @ j <
\      y1 @ j 10 + >
\      or not if
\        y1 @ j max y1 !
\        y2 @ j 10 + min y2 !
\        blit
\      then
    loop
    count-overlap 
    s>d total 2@ d+ total 2!
  10 +loop

  ;
  
  part1

bye

