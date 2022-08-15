include  ../fth/advent2021.fs

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

: print-nums ( buf len )
    begin
        get-num ( buf len num valid? )
    while
        .
    repeat 2drop drop ;

: read-nums-file ( fname flen -- )
    foreach-file-line
        print-nums cr
    repeat ;

s" tinput.txt" read-nums-file

bye