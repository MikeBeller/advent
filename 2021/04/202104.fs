include  ../fth/advent2021.fs

3000 constant max-len
max-len vec data
variable ndraws 0 ndraws !
variable nboards 0 nboards !
100 constant mark-offset

: draw ( i -- n )
    dup 0 ndraws @ within invert abort" draw index out of bounds"
    data vec@ ;

\ vector index of board b, row r, column c
: board-index { b r c -- i }
    b 0 nboards @ within invert abort" board index out of bounds"
    r 0 5 within invert abort" invalid row index"
    c 0 5 within invert abort" invalid column index"
    ndraws @
    b 25 * +
    r 5 * +
    c + ;

: board-get ( b r c -- n )
    board-index data vec@
    ;

: board-set ( n b r c -- )
    board-index data vec! ;

: marked? ( b r c -- t/f )
    board-get mark-offset >= ;

: mark { b r c -- }
    b r c marked? invert if
        b r c board-get
        mark-offset +
        b r c board-set
    then ;

: get-unmarked { b r c -- n }
    b r c board-get
    dup mark-offset >= if
        mark-offset -
    then ;

\ Append all numbers on a line to the 'data' vector
: read-nums ( buf len )
    begin
        get-num ( buf len num valid? )
    while
        data vec,
    repeat 2drop drop ;

\ Read and store all numbers in a file into data vector
\ Keep track of the number of 'draws' ( number of numbers on first line )
\ And number of boards 'nboards' ( number of all other numbers divided by 25 )
: read-data ( fname flen -- )
    data vec>clear
    foreach-file-line
        read-nums
        ffl-nlines @ 1 = if
            data vec>len ndraws !
        then
    ffl-repeat 
    data vec>len ndraws @ - 25 / nboards !
    ;

T{ s" tinput.txt" read-data ndraws @ nboards @ data vec>len -> 27 3 102 }T
T{ 0 1 1 board-index -> 33 }T
T{ 0 1 1 board-get 2 4 4 board-get -> 2 7 }T
T{ 0 1 1 mark 0 1 1 board-get 0 1 1 get-unmarked 0 1 1 marked? -> 102 2 -1 }T

bye