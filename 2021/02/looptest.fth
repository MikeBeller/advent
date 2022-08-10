\ old -- this code is for pforth not updated to gforth

: hello ." hello" cr ;
: rep 0 postpone literal postpone do ; immediate
: bar rep hello loop ;
9 bar
hello


create ffl-buf 1024 allot
variable ffl-fid

\ open a file for reading and put fid in ffl-fid
: ffl-open-file ( addr u -- fid )
  r/o open-file abort" open failed"
  ffl-fid !
  ;

\ read a line of max length 1022 into ffl-buf 
\ return nchars and !eof flag
: ffl-read-line ( -- n !eof ) ffl-buf 1022 ffl-fid @ read-line throw ;

: foreach-file-line ( addr u -- ) \ file name string
    postpone ffl-open-file
  postpone begin
    postpone ffl-read-line \ ( length !eof )
  postpone while
    postpone ffl-buf postpone swap ; immediate

: ffl-repeat postpone repeat postpone drop ; immediate

: test1 ( addr u )
  foreach-file-line
    type cr
  ffl-repeat
  ;

s" tinput.txt" test1

s" tinput.txt" foreach-file-line type cr ffl-repeat


