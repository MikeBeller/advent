: bounds ( addr n -- addr2 addr1 ) cells over + swap ; \ end and start address of array arr with length n

create tdata 199 , 200 , 208 , 210 , 200 , 207 , 240 , 269 , 260 , 263 ,
10 constant tlen

: isless ( addr -- 1/0 ) \ 1 if addr[0] < addr[1]
    dup cell - @ swap @ < negate ;

: part1 ( arr len -- n ) \ number of times arr[i] < arr[i+1]
  0 -rot \ poke zero sum above loop control stuff
  bounds cell+ \ start with 1th element of array (not zeroth)
  ?do
    i isless
    +
  cell +loop ;

." Test "
tdata tlen part1 .
cr

s" input.txt" r/o  open-file abort" open failed"
.s

1024 constant max-line
create line-buf max-line allot ;

line-buf max-line rot ( buf 1024 fileid )
begin
    read-line throw
while
repeat drop

