\ simple variable-length cell arrays with maximum length
\ structure is 
\  maxlen curlen < maxlen cells >

include  ../fth/t_tools.fth

: vec ( maxlen "name" -- ) create
    dup ,
    0 ,
  ;

: vec>max ( vec -- vmax ) @ ;
: vec>len ( vec -- vlen ) cell + @ ;
: vec>checkmax ( n vec -- ) vec>max >= abort" vec index beyond vec>max" ;
: vec>len! ( n vec -- vlen ) 2dup vec>checkmax cell + ! ;
: vec>checklen ( n vec -- ) vec>len >= abort" vec index beyond vec>len" ;
: vec@ ( n vec -- v ) 2dup vec>checklen swap 2 + cells + @ ;
: vec! ( v n vec -- ) 2dup vec>checklen swap 2 + cells + ! ;
: vec, ( v vec -- )
  dup vec>len ( v vec n-1 ) 
  1+ 2dup vec>len! ( v vec n )
  swap ( v n vec )
  2dup vec>checklen vec! ;

3 vec gt1

T{ gt1 vec>len gt1 vec>max }T{ 0 3 }T
T{ 3 gt1 vec, 0 gt1 vec@ }T{ 3  }T


