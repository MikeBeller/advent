include  ../fth/advent2021.fth

16 constant max-bits
create cnt max-bits cells allot \ will hold count of 1's in each column

: count-ones ( addr n -- )
  0 do \ ( addr )
    dup i + c@ 49 = if
      1 cnt i cells + +!
    then
  loop drop ;

\ cnt max-bits cells 0 fill cnt @ cnt 1 cells + @ s" 01101" count-ones cnt @ cnt 1 cells + @ .s
T{ cnt max-bits cells 0 fill s" 01101" count-ones cnt @ cnt 1 cells + @ }T{ 0 1 }T

: compute-gamma ( nbits nlines -- )
  2/ 0 rot  \ ( nlines/2 gamma nbits )
  0 do  \ ( nlines/2 gamma )
    2*
    cnt i cells + @ ( nlines/2 gamma count[i] )
    2 pick  ( nlines/2 gamma count[i] nlines/2 )
    > if
      1+
    then
  loop swap drop
;

T{ cnt dup 7 swap ! cell+ dup 5 swap ! cell+ dup 8 swap ! cell+ dup 7 swap ! cell+ 5 swap ! 5 12 compute-gamma }T{ 22 }T

: part1 { fname flen | nlines nbits bufaddr buflen -- gamma*epsilon }
  \ set cnt[i] to number of 1 bits in column i
  fname flen foreach-file-line \ ( bufaddr buflen )
    -> buflen -> bufaddr
    nbits 0= if
      buflen -> nbits \ on first loop, set number of bits
      cnt nbits cells 0 fill
    then
    buflen nbits <> abort" invalid line width"
    1 +-> nlines
    bufaddr nbits count-ones
  ffl-repeat

  nbits 0 do
    cnt i cells + ? bl emit
  loop cr

  nbits nlines compute-gamma

  dup \ ( gamma gamma )
  invert 1 nbits lshift 1- and  \ compute 1's complement of gamma
  *  \ gamma * epsilon
  ;


\ T{ s" tinput.txt" part1  }T{ 198 }T
\ ." PART1: " s" input.txt" part1 . cr

\ : t1 
\ s" input.txt" foreach-file-line
\   type cr
\ ffl-repeat ;
\ t1

