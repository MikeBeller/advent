include  ../fth/t_tools.fth

1024 constant line-buf-len
create line-buf line-buf-len allot ; 

: file-foreach-line { fname flen xt buf blen | fid max-line --  }
  \ apply xt to each line in file fname using buffer buf/len
  \ because you can have extra args on the stack when you call this,
  \ it can work as a "reduce" also (or a map)
  fname flen r/o open-file abort" open failed" -> fid
  blen 2 - -> max-line \ max line is two bytes shorter than the buffer len
  begin
    buf max-line fid read-line throw \ length !eof
  while
    buf swap xt execute \ call the xt with ( buf line-len )
  repeat drop ;

: >num ( buf len -- n )
  0 0 2swap >number
  2drop drop
  ;

T{ s" 123" >num }T{ 123 }T

: sum >num + ;
T{ 0 s" tinput.txt" ' sum line-buf line-buf-len file-foreach-line }T{ 2256 }T

: diff1 { last total buf len | num -- }
  buf len >num -> num
  last -1 <>
  if
    num last >
    if
      1 +-> total
    then
  then
  num -> last
  last total
  ;

T{ -1 0 s" 123" diff1 }T{ 123 0 }T
T{ 7 0 s" 123" diff1 }T{ 123 1 }T

: part1 ( fname flen -- )
  -1 0 2swap \ ( last total buf len )
   ['] diff1 line-buf line-buf-len file-foreach-line \ ( last total )
   swap drop
   ;

T{ s" tinput.txt" part1 }T{ 7 }T

." PART1: " s" input.txt" part1 . cr
