: btwn ( k a b -- a <= k <= b )
  2 pick >=
  -rot >=
  and ;
  
: ddig ( n k -- n' k)
  dup 48 57 btwn
  if
    dup 48 - rot 10 * + swap
  then
    drop
  else ;

: test
    begin
        key
        dup
        .
        -1
        =
    until ;

test

