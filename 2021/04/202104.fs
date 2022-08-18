include  ../fth/advent2021.fs

3000 constant max-len
max-len vec data
variable ndraws 0 ndraws !
variable nboards 0 nboards !
128 constant mark-mask
mark-mask invert constant mark-unmask

: mark mark-mask or ;
: unmark mark-unmask and ;
: marked? mark-mask and 0<> ;

T{ 7 mark dup marked? swap unmark marked? -> true false }T

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
    board-index data vec@ ;

: board-set ( n b r c -- )
    board-index data vec! ;

: board-marked? ( b r c -- t/f )
    board-get marked? ;

: board-mark ( b r c -- )
    board-index
    dup data vec@
    mark ( index v )
    swap data vec! ;

: board-unmark ( b r c -- )
    board-index
    dup data vec@
    unmark
    swap data vec! ;

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
T{ 0 1 1 board-mark 0 1 1 board-get dup marked? swap unmark  -> true 2 }T
T{ 2 4 4 board-mark 2 4 4 board-marked? 2 4 4 board-unmark 2 4 4 board-marked? -> true false }T

: find-in-row 0 0 { n b r c found? -- c found? }
    begin
        b r c board-get
        n = if
            true to found?
        then
        c 4 = found? or invert
    while
        c 1+ to c
    repeat
    c found? ;

T{ 14 0 2 find-in-row -> 2 -1 }T
T{ 14 1 2 find-in-row -> 4 0 }T

: find-in-board 0 0 0 { n b r c found? -- r c t/f }
    begin
        n b r find-in-row ( c t/f )
        swap to c
        if
            true to found?
        then
        r 4 = found? or invert
    while
        r 1+ to r
    repeat
    r c found? ;

T{ 26 2 find-in-board -> 2 3 -1 }T
T{ 26 1 find-in-board -> 4 4 0 }T

: row-full? { b r -- t/f }
    -1
    5 0 do
        b r i board-marked? and
    loop ;

T{ 2 3 0 board-mark 2 3 1 board-mark 2 3 2 board-mark 2 3 3 board-mark 2 3 4 board-mark
    2 3 row-full?
    2 3 1 board-unmark 2 3 row-full?  -> -1 0 }T


: column-full? { b c -- t/f }
    -1
    5 0 do
        b i c board-marked? and
    loop ;

: winner? { b r c -- t/f }
    b r row-full?
    b c column-full?
    or ;

T{ 2 3 0 swap board-mark 2 3 1 swap board-mark 2 3 2 swap board-mark 2 3 3 swap board-mark 2 3 4 swap board-mark
    2 3 column-full?
    2 3 1 swap board-unmark 2 3 column-full? -> -1 0 }T

: do-draw { n - b r c t/f }
    nboards @ 0 do
        i
        n draw i find-in-board ( b r c found? )
        if ( b r c )
            2 pick over row-full?
            2 pick swap column-full?
            or if
                true leave ( b r c true )
            then
        then ( b r c )
        i nboards @ = if
            false leave ( b r c false )
        then ( b r c )
        2drop drop ( )
    loop ;

: part1 { fname flen -- b }
    read-data
    ndraws @ 0 do
        i do-draw .s cr
        if ( b r c )
            ." winner " rot . ." on draw " i . cr
        then
    loop ;

s" tinput.txt" part1 .s 

bye

\\ need to complete do-draw
\\ probably should create 'mark-row' and 'mark-column' to simplify testing
