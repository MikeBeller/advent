

: tloop ( n -- )
    0 swap 0 do
        i +
    loop
;

1000000000 tloop . cr
bye