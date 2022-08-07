include  ../fth/advent2021.fth

16 constant max-bits
create counts max-bits cells allot \ will hold count of 1's in each column
: countn ( n -- addr) cells counts + ;

: count-ones ( addr n -- )
  0 do \ ( addr )
    dup i + c@ 49 = if
      1 i countn +!
    then
  loop drop ;

\ cnt max-bits cells 0 fill cnt @ cnt 1 cells + @ s" 01101" count-ones cnt @ cnt 1 cells + @ .s
T{ counts max-bits cells 0 fill s" 01101" count-ones 0 countn @ 1 countn @ }T{ 0 1 }T

: compute-gamma ( nbits nlines -- )
  2/ 0 rot  \ ( nlines/2 gamma nbits )
  0 do  \ ( nlines/2 gamma )
    2*
    i countn @ ( nlines/2 gamma count[i] )
    2 pick  ( nlines/2 gamma count[i] nlines/2 )
    > if
      1+
    then
  loop swap drop
;

T{ 7 0 countn ! 5 1 countn ! 8 2 countn ! 7 3 countn ! 5 4 countn ! 5 12 compute-gamma }T{ 22 }T

7 5 8 7 5  5 12
: part1 { fname flen nbits -- gamma*epsilon }

  \ set cnt[i] to number of 1 bits in column i
  counts nbits cells 0 fill
  fname flen foreach-file-line \ ( bufaddr buflen )
    dup nbits <> abort" invalid line width"  ( bufaddr nbits )
    count-ones
  ffl-repeat

  nbits ffl-nlines @ compute-gamma

  \ compute gamma * epsilon
  dup \ ( gamma gamma )
  invert 1 nbits lshift 1- and  \ compute 1's complement of gamma
  *  \ gamma * epsilon
  ;

T{ s" tinput.txt" 5 part1  }T{ 198 }T
." PART1: " s" input.txt" 12 part1 . cr
