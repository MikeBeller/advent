include  ../fth/t_tools.fth

1024 constant foreach-line-buf-len
create foreach-line-buf foreach-line-buf-len allot ; 

: file-foreach-line { fname flen xt | fid max-line -- }   ( i*x addr u -- j*x )
  \ apply xt to each line in file fname using a single global buffer
  \ because you can have extra args on the stack when you call this,
  \ it can work as a "reduce" also (or a map)
  fname flen r/o open-file abort" open failed" -> fid
  foreach-line-buf-len 2 - -> max-line \ max line is two bytes shorter than the buffer len
  begin
    foreach-line-buf max-line fid read-line throw \ length !eof
  while
    foreach-line-buf swap xt execute \ call the xt with ( buf line-len )
  repeat drop ;

: >num ( buf len -- n )
  0 0 2swap >number
  2drop drop
  ;

T{ s" 123" >num }T{ 123 }T

