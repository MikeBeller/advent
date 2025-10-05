system

include ttester.f
include locals.f

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

\ #nn @ x1,x2 WxH
: scan-poly ( addr n  -- x1 y1 x2 y2 )
  0 0 0 0 locals| y2 x2 y1 x1 |
  [char] @ scan
  2 /string /number d>s to x1
  1 /string /number d>s to y1
  2 /string /number d>s x1 + to x2
  1 /string /number d>s y1 + to y2
  2drop
  x1 y1 x2 y2
  ;

T{  s" #12 @ 345,678: 77,88"  scan-poly -> 345 678 422 766 }T

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

T{ 345 678 422 766 0 poly save-poly 0 poly get-poly -> 345 678 422 766 }T


: read-data ( -- )
  s" T1803.TXT" R/O open-file abort" open-file"
  to filehandle

  begin
    linebuf bufsize filehandle read-line abort" read-line"   \ nread eof(0)
  while
    linebuf swap scan-poly   \ x1 y1 x2 y2
    npolys poly save-poly
    npolys 1+ to npolys
  repeat drop ;

read-data 
cr ." READ " npolys . ." polygons" cr

create grid 10000 allot
2variable total
create pbuf poly-size allot

: blit ( x1 y1 x2 y2 -- )
  locals| y2 x2 y1 x1 |
  y2 y1 ?do  \ j is y 
    x2 x1 ?do \ i is x
      j 1000 * i + grid +   \ addr of byte to increment
      dup c@ 1+ swap c!     \ increment it
    loop
  loop
 ;

: count-overlap ( -- n )
  0
  10000 0 do
    grid i + c@ 1 > if
      1+
    then
  loop
  ;

\ fyi cr

: part1 ( -- d )
  0 0 0 0 locals| y2 x2 y1 x1 |
  0. total 2!
  1000 0 do
    grid 10000 erase
    npolys 0 do
      i poly get-poly to y2 to x2 to y1 to x1
      y2 j > y1 j 10 + < and if                         \ if y2 > j and y1 < j+10
        x1                                                \ blit x1 (max(j,y1)-j) x2 (min(j+10, y2)-j)
        j y1 max j -
        x2
        j 10 + y2 min j -
        blit
      then
    loop
    total 2@ count-overlap m+ total 2!
  10 +loop
  total 2@
  ;
  
part1
cr ." PART1: " d. cr

create has-overlaps? npolys allot 

: poly-overlap? ( a b -- t/f )
  locals| a b |
  a poly px1 @ b poly px1 @ max
  a poly px2 @ b poly px2 @ min
  <
  a poly py1 @ b poly py1 @ max
  a poly py2 @ b poly py2 @ min
  <
  and
;

0 value ov

: part2 ( -- d)
  npolys 0 do 
    \ ." LOOP " i . cr
    0 to ov
    npolys 0 do
      i j <> if
        i j poly-overlap? if
          1 to ov
          leave
        then
      then
    loop
    ov not if
      i 1+
      leave
    then
  loop ;

cr ." PART2: " part2 . cr

bye

