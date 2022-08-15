require ../fth/ttester.fs
require ../fth/vec.fs

create ffl-buf 1024 allot \ single global buffer for foreach-file-line
variable ffl-fid
variable ffl-nlines

: ffl-open-file ( addr u -- fid )
  r/o open-file abort" open failed"
  ffl-fid !
  0 ffl-nlines !
  ;

\ read a line of max length 1022 into ffl-buf 
: ffl-read-line ( -- n !eof )
  ffl-buf 1022 ffl-fid @ read-line throw
  1 ffl-nlines +! ;

: ffl-close-file ( -- ) ffl-fid @ close-file drop ;

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

: ffl-repeat
  postpone repeat
  postpone drop
  postpone ffl-close-file ; immediate

\ convert positive number string to number
: >num ( buf len -- n )
  0 0 2swap >number
  2drop drop ;

T{ s" 123" >num -> 123 }T

: binary 2 base ! ;


: skip-nondigit ( buf len -- buf2 len2 )
    begin ( buf len )
        dup
        if
            over c@ ( buf len char )
            48 58 within ( buf len isdigit? )
            if
                true ( buf len true )
            else
                1- swap 1+ swap false ( buf+1 len-1 false )
            then
        else
            true
        then
    until ;

T{ create tbuf bl c, char , c, 49 c, 57 c, char , c, 52 c, 53 c, tbuf 7 skip-nondigit -> tbuf 2 + 5 }T

: get-num ( buf len -- buf len num ok )
    skip-nondigit  ( buf1 len1 )
    dup
    if
        dup >r
        0 0 2swap >number ( udL udH buf2 len2 )
        dup r> <>
        if
            2swap drop true ( buf2 len2 udL ok )
        else
            2swap 2drop 0 0
        then
    else
        0 0 ( buf1 len1 0 0 )
    then ;

T{ tbuf 7 get-num 2swap get-num 2swap get-num 2swap 2drop -> 19 -1 45 -1 0 0 }T
