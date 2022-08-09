\ simple variable-length cell arrays with maximum length
\ structure is 
\  maxlen curlen < maxlen cells >

require  ../fth/ttester.fs

: vec ( maxlen "name" -- ) create
    dup , ( maxlen )
    0 ,
    cells allot
  ;

: vec>max ( vec -- vmax ) @ ;
: vec>len ( vec -- vlen ) cell + @ ;
: vec>checkmax ( n vec -- ) vec>max > abort" vec len beyond vec>max" ;
: vec>len! ( n vec -- vlen ) 2dup vec>checkmax cell + ! ;
: vec>checklen ( n vec -- ) vec>len >= abort" vec index beyond vec>len" ;
: vec@ ( n vec -- v ) 2dup vec>checklen swap 2 + cells + @ ;
: vec! ( v n vec -- ) 2dup vec>checklen swap 2 + cells + ! ;
: vec, ( v vec -- )
  dup vec>len ( v vec n ) 
  2dup 1+ ( v vec n vec n+1 )
  swap vec>len! ( v vec n )
  swap ( v n vec )
  2dup vec>checklen vec! ;

\ push n elements of vector from stack items in order
: vec#, ( v1 v2 v3... n vec -- )
  swap
  dup 0 ?do ( v1 v2 v3... vec n )
    2dup ( v1 v2 v3... vec n vec n )
    i - 2 + roll ( v1 v2 vec n vec v3 )
    swap ( v1 v2 vec n v3 vec )
    vec, ( v1 v2 vec n )
  loop
  drop drop ;

3 vec gt1
: read-after-end
  gt1 dup ( gt1 gt1 )
  vec>len ( gt1 len )
  swap vec@ ; \ abort
: test-read-after-end ['] read-after-end catch 99 ;

\ set length to zero (doesn't affect max)
: vec>clear ( vec -- ) 0 swap vec>len! ;

\ fill entire vector ( vec>len cells ) with value v
: vec>fill ( v vec -- )
  { v vc }
  vc vec>len
  0 ?do
    v i vc vec!
  loop ;

\ filter a vector in place based on a predicate
\ keep only items for which the predicate xt  ( v -- 1/0 ) returns truthy
: vec>filter ( xt vec -- )
  0 { xt vc p }
  vc vec>len 0
  ?do
    i vc vec@ ( vec[i] )
    dup >r
    xt execute
    if  ( vec[i] )
      r@ p vc vec!
      p 1+ to p
    then
    r> drop
  loop
  p vc vec>len! ;

T{ gt1 vec>len gt1 vec>max -> 0 3 }T
T{ 3 gt1 vec, 5 gt1 vec, 0 gt1 vec@ 1 gt1 vec@ gt1 vec>len -> 3 5 2 }T
T{ gt1 vec>clear 3 gt1 vec, 5 gt1 vec, 99 gt1 vec>fill 0 gt1 vec@ 1 gt1 vec@ gt1 vec>len -> 99 99 2 }T
T{ test-read-after-end swap drop -> 99 }T
T{ gt1 vec>clear 5 7 9 3 gt1 vec#, 0 gt1 vec@ 1 gt1 vec@ 2 gt1 vec@ gt1 vec>len -> 5 7 9 3 }T

T{ gt1 vec>clear 6 0 9 3 gt1 vec#, ' 0<> gt1 vec>filter gt1 vec>len -> 2 }T
