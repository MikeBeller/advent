include  ../fth/t_tools.fth

create ffl-buf 1024 allot ; 
variable ffl-fid ;

: ffl-open-file ( addr u -- fid )
  r/o open-file abort" open failed"
  ffl-fid !
  ;

\ read a line of max length 1022 into ffl-buf 
: ffl-read-line ( -- n !eof ) ffl-buf 1022 ffl-fid @ read-line throw ;

\ foreach-file-line -- a special loop structure for looping over each line in a file
\ 
\   s" input.txt" foreach-file-line
\     type cr
\   ffl-repeat ;
: foreach-file-line ( addr u -- ) \ file name string
    postpone ffl-open-file
  postpone begin
    postpone ffl-read-line \ ( length !eof )
  postpone while
    postpone ffl-buf postpone swap ; immediate

: ffl-repeat postpone repeat postpone drop ; immediate

\ convert positive number string to number
: >num ( buf len -- n )
  0 0 2swap >number
  2drop drop ;

T{ s" 123" >num }T{ 123 }T
