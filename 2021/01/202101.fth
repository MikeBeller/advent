include  ../fth/advent2021.fth

: part1 { fname flen | last total num -- }
  -1 -> last
  fname flen foreach-file-line \ ( buf n )
    >num -> num
    last -1 <>
    if num last >
      if
        1 +-> total
      then
    then
    num -> last
  ffl-repeat
  total
  ;

T{ s" tinput.txt" part1 }T{ 7 }T
." PART1: " s" input.txt" part1 . cr

: part2 { fname flen | last1 last2 last3 total num -- }
  -1 -> last1 -1 -> last2 -1 -> last3
  fname flen foreach-file-line \ ( buf n )
    >num -> num
      last1 -1 <>
      if
        num last2 + last3 +
        last1 last2 + last3 +
        >
        if
          1 +-> total
        then
      then
    last2 -> last1 last3 -> last2 num -> last3
  ffl-repeat
  total ;

T{ s" tinput.txt" part2 }T{ 5 }T
." PART2: " s" input.txt" part2 . cr
