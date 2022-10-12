

: tloop ( n -- )
    0 swap 0 do
        i +
    loop
;

100000000 tloop . cr
bye