: btwn ( k a b -- a <= k <= b )
2 pick >=
-rot >=
and ;

: ddig ( n k -- n' k) dup 48 - rot 10 * + swap ;

( read a decimal number from keyboard -- end with number and first non-digit key seen )
: dnum ( <ks> -- n k )
  0
  begin
      key
      dup
      48 57 btwn
  while
      ddig
      drop
  repeat drop ;

( sum the numbers in the input )
: sumfile
    0
    begin
        dnum
        -1 = not
    while
        +
    repeat ;

sumfile .
