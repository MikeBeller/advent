include  ../fth/advent2021.fs

2000 vec nums

: bin>num ( addr nbits -- n )
  dup 0= abort" invalid binary number"
  2 base ! evaluate decimal ;

T{ s" 10101" bin>num -> 21 }T

: read-nums { fname flen nbits -- }
  nums vec>clear
  fname flen foreach-file-line \ ( bufaddr buflen )
    dup nbits <> abort" invalid line width"  ( bufaddr nbits )
    bin>num ( num )
    nums vec,
  ffl-repeat ;

T{ s" tinput.txt" 5 read-nums nums vec>len -> 12 }T

: bit ( val nbit -- 1/0 )
    >r
    1 r@ lshift ( val 1<<nbit )
    and
    r> rshift 1 and ;

T{ binary 10101 decimal 2 bit -> 1 }T
T{ binary 10101 decimal 3 bit -> 0 }T

: most-common-bit { nbit -- 1/0 }
  0
  nums vec>len 0 do ( total )
    i nums vec@ nbit bit ( total 1/0 )
    +
  loop 
  nums vec>len 2/ > 1 and ;

: tdata nums vec>clear binary 00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010 decimal 12 nums vec#, ;

T{ tdata 4 most-common-bit -> 1 }T
T{ tdata 3 most-common-bit -> 0 }T

: compute-gamma ( nbits -- gamma )
  0 swap 0 swap ( 0 0 nbits-1 )
  do  \ ( gamma )
    2*
    i most-common-bit
    +
  -1 +loop ;

: part1 { fname flen nbits -- gamma*epsilon }
  fname flen nbits read-nums
  nbits compute-gamma

  \ compute gamma * epsilon
  dup \ ( gamma gamma )
  invert 1 nbits lshift 1- and  \ compute 1's complement of gamma
  *  \ gamma * epsilon
  ;

T{ s" tinput.txt" 5 part1  -> 198 }T
." PART1: " s" input.txt" 12 part1 . cr


: o2rating { fname flen nbits -- o2rating }
  fname flen nbits read-nums
;

\ s" tinput.txt" 5 o2rating
