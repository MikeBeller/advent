
1024 constant line-buf-len
create line-buf line-buf-len allot ; 

: map-file { fname flen xt buf blen | fid max-line --  } \ map xt over each line in file fname using buffer buf/len
  fname flen r/o open-file abort" open failed" -> fid
  blen 2 - -> max-line \ max line is two bytes shorter than the buffer len
  begin
    buf max-line fid read-line throw \ length !eof
  while
    buf swap xt execute \ call the xt with ( buf line-len )
  repeat drop ;

\ s" tinput.txt" ' type line-buf line-buf-len .s map-file


: >num ( buf len -- n )
  0 0 2swap >number
  2drop drop
  ;

variable last
variable total

: diff1 ( buf len -- )
  ." hello " .s
  >num
  last @ -1 <>
  if
    dup last @ >
    if
      total +! 
    then
  then ( num )
  last ! 
;



: part1 ( fname flen -- )
  0 total !
  -1 last !
   ['] diff1 line-buf line-buf-len map-file
   total @
   ;

s" tinput.txt" part1 .
