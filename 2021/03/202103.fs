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
  ." vec len " nums vec>len . cr
  nums vec>len 0 do ( total )
    i nums vec@ nbit bit ( total 1/0 )
    +
  loop 
  nums vec>len 2/ > 1 and ;

: tdata s" tinput.txt" 5 read-nums ;

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

\ keep items with bitval in bit number nbit
: keeper .s cr over and ;
: keep-with-bit ( bitval nbit )
  lshift  ( bitval<<nbit )
  ['] keeper nums vec>filter drop    \ bitval<<nbit t/f
;

T{ tdata 1 4 keep-with-bit nums vec>len -> 7 }T

: o2rating { fname flen nbits -- o2rating }
  fname flen nbits read-nums

  0 nbits 1- do
    i most-common-bit ( mcb )
    i keep-with-bit
    nums vec>len dup . cr 1 = if leave then
  -1 +loop ;

s" tinput.txt" 5 o2rating . cr

