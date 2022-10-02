fyi
: bin>num ( addr nbits -- n )
  dup 0= abort" invalid binary number"
  2 base ! evaluate decimal ;

s" 10101" bin>num 21 <> abort" bin>num"

: bit ( val nbit -- 1/0 )
    >r
    1 r@ lshift ( val 1<<nbit )
    and
    r> rshift 1 and ;

binary 10101 decimal 2 bit 1 <> abort" bit 1"
binary 10101 decimal 3 bit 0 <> abort" bit 0"

\ number of one-bits in a specific bit
\ position in a list of numbers

create data
binary
00100 ,
11110 ,
10110 ,
10111 ,
10101 ,
01111 ,
00111 ,
11100 ,
10000 ,
11001 ,
00010 ,
01010 ,
decimal
variable ndata
here data - 2/ 2 - ndata !

: num-one-bits ( nbit -- n )
  0 ( nbit total )
  data dup ndata @ cells + swap ( nbit total data+n data )
  ?do ( nbit total )
    i @ ( nbit total x )
    2 pick bit ( nbit total 1/0 )
    + ( nbit total )
    2
  +loop nip ;

  0 num-one-bits 5 <> abort" num-one-bits 0"
  2 num-one-bits 8 <> abort" num-one-bits 2"

." ALL TESTS PASSED"
fyi
bye
