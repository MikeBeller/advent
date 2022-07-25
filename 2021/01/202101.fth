: bounds ( addr n -- addr2 addr1 ) cells over + swap ; \ end and start address of array arr with length n

create tdata 199 , 200 , 208 , 210 , 200 , 207 , 240 , 269 , 260 , 263 ,
10 constant tlen

: isless ( addr -- 1/0 ) \ 1 if addr[0] < addr[1]
    dup cell - @ swap @ < negate ;

: part1 ( arr len -- n ) \ n is number of instances where arr[i] < arr[i+1]
  0 -rot \ ( 0 arr len )
  bounds cell+ \ ( 0 &arr[len] &arr[1] ) start with 1th element of array
  ?do
    i isless
    +
  cell +loop ;

." Test "
tdata tlen part1 .
cr

variable fid
s" tinput.txt" r/o  open-file abort" open failed" fid !

1022 constant max-line
create line-buf max-line 2 + allot ; \ 2 extra bytes for line terminator

variable dlen
0 dlen !
create data
decimal
begin
  line-buf max-line fid @ read-line throw \ length !eof
while \ length
  line-buf swap \ line-buf length
  0 -rot
  2dup type cr
  .s
  >number .s 2drop \ num
  \ .s
  ,
  1 dlen +!
repeat drop

.s
." Part1: "
data dlen @ part1 .
\ data dlen part1 .
cr