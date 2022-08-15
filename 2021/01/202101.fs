include  ../fth/advent2021.fs

: part1 -1 0 0 { fname flen last total num -- }
  fname flen foreach-file-line \ ( buf n )
    >num to num
    last -1 <>
    if num last >
      if
        1 total + to total
      then
    then
    num to last
  ffl-repeat
  total
  ;

T{ s" tinput.txt" part1 -> 7 }T
." PART1: " s" input.txt" part1 . cr

: part2 -1 -1 -1 0 0 { fname flen last1 last2 last3 total num -- }
  fname flen foreach-file-line \ ( buf n )
    >num to num
      last1 -1 <>
      if
        num last2 + last3 +
        last1 last2 + last3 +
        >
        if
          1 total + to total
        then
      then
    last2 to last1
    last3 to last2
    num to last3
  ffl-repeat
  total ;

T{ s" tinput.txt" part2 -> 5 }T
." PART2: " s" input.txt" part2 . cr

bye