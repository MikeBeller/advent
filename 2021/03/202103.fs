include  ../fth/advent2021.fs

2000 vec data
2000 vec nums

: bin>num ( addr nbits -- n )
  dup 0= abort" invalid binary number"
  2 base ! evaluate decimal ;

T{ s" 10101" bin>num -> 21 }T

: read-data { fname flen nbits -- }
  data vec>clear
  fname flen foreach-file-line \ ( bufaddr buflen )
    dup nbits <> abort" invalid line width"  ( bufaddr nbits )
    bin>num ( num )
    data vec,
  ffl-repeat ;

T{ s" tinput.txt" 5 read-data data vec>len -> 12 }T

: bit ( val nbit -- 1/0 )
    >r
    1 r@ lshift ( val 1<<nbit )
    and
    r> rshift 1 and ;

T{ binary 10101 decimal 2 bit -> 1 }T
T{ binary 10101 decimal 3 bit -> 0 }T

: num-one-bits { nbit -- n }
  0
  nums vec>len 0 ?do ( total )
    i nums vec@ nbit bit ( total 1/0 )
    +
  loop ;

: tdata s" tinput.txt" 5 read-data data nums vec>copy ;

T{ tdata 4 num-one-bits -> 7 }T
T{ tdata 3 num-one-bits -> 5 }T

: compute-gamma ( nbits -- gamma )
  0 swap 0 swap ( 0 0 nbits-1 )
  do  \ ( gamma )
    2*
    i num-one-bits
    nums vec>len 2/ >= if
      1 +
    then
  -1 +loop ;

: part1 { fname flen nbits -- gamma*epsilon }
  fname flen nbits read-data
  data nums vec>copy
  nbits compute-gamma

  \ compute gamma * epsilon
  dup \ ( gamma gamma )
  invert 1 nbits lshift 1- and  \ compute 1's complement of gamma
  *  \ gamma * epsilon
  ;

T{ s" tinput.txt" 5 part1  -> 198 }T
." PART1: " s" input.txt" 12 part1 . cr

\ keep items with bitval in bit number nbit
: keep1 over and ;
: keep0 over and 0= ;

: keep-ones ( bitnum -- )
  1 swap lshift
  ['] keep1 nums vec>filter
  drop ;

: keep-zeros ( bitnum -- )
  1 swap lshift
  ['] keep0 nums vec>filter
  drop ;

T{ tdata 4 keep-ones nums vec>len -> 7 }T
T{ tdata 4 keep-zeros nums vec>len -> 5 }T

\ compute o2rating of nums vector (destructive)
: o2rating { nbits -- o2rating }
  0 nbits 1- ?do
    i num-one-bits
    2* nums vec>len >= if
      i keep-ones
    else
      i keep-zeros
    then
    nums vec>len 1 = if leave then
  -1 +loop 
  0 nums vec@ ;

\ compute co2rating of nums vector (destructive)
: co2rating { nbits -- co2rating }
  0 nbits 1- ?do
    i num-one-bits
    2* nums vec>len < if
      i keep-ones
    else
      i keep-zeros
    then
    nums vec>len 1 = if leave then
  -1 +loop
  0 nums vec@ ;


T{ s" tinput.txt" 5 read-data data nums vec>copy 5 o2rating -> 23 }T
T{ s" tinput.txt" 5 read-data data nums vec>copy 5 co2rating -> 10 }T

: part2 { fname flen nbits -- o2rating*co2rating }
  fname flen nbits read-data 
  data nums vec>copy nbits o2rating
  data nums vec>copy nbits co2rating
  *
  ;

: part2-fast { nbits -- o2rating*co2rating } 
  data nums vec>copy nbits o2rating
  data nums vec>copy nbits co2rating
;

T{ s" tinput.txt" 5 part2  -> 230 }T
." PART2: " s" input.txt" 12 part2 . cr

: bench 
  ." Running benchmark -- use unix time "
  s" input.txt" 12 read-data
  1000 0 do
    12 part2-fast
  loop ;

  ." We are 5 x faster than python and 3x faster than elixir! "

bench

bye
