include  ../fth/advent2021.fth

T{ s" 123" >num }T{ 123 }T

: sum >num + ;
T{ 0 s" tinput.txt" ' sum file-foreach-line }T{ 2256 }T

: diff1 { last total buf len | num -- } \ ( last total buf len -- last total )
  buf len >num -> num
  last -1 <>
  if
    num last >
    if
      1 +-> total
    then
  then
  num -> last
  last total
  ;

T{ -1 0 s" 123" diff1 }T{ 123 0 }T
T{ 7 0 s" 123" diff1 }T{ 123 1 }T

: part1 ( fname flen -- )
  -1 0 2swap \ ( last total buf len )
   ['] diff1 file-foreach-line \ ( last total )
   nip ( total )
   ;

T{ s" tinput.txt" part1 }T{ 7 }T

." PART1: " s" input.txt" part1 . cr

: diff3 { last1 last2 last3 total buf len | num -- }
  ( last1 last2 last3 total buf len -- last1 last2 last3 total )
  buf len >num -> num
  last1 -1 <>
  if
    num last2 + last3 +
    last1 last2 + last3 +
    >
    if
      1 +-> total
    then
  then
  last2 last3 num total
  ;


: part2 ( fname flen -- )
  -1 -1 -1 0 5 roll 5 roll \ ( last1 last2 last3 total fname flen )
   ['] diff3 file-foreach-line \ ( last1 last2 last3 total )
   nip nip nip ( total )
   ;

T{ s" tinput.txt" part2 }T{ 5 }T

." PART2: " s" input.txt" part2 . cr
