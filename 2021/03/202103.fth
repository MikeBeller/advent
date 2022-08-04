include  ../fth/advent2021.fth

create cnt 5 cells allot  \ count of 1s in each column
variable nlines

: print-cnt
  ." nlines " nlines ? cr
  5 0 do cnt i cells + @ . cr loop ;

: part1 ( addr n -- u )
  \ set cnt[i] to number of 1 bits in column i
  cnt 5 cells 0 fill
  0 nlines !
  foreach-file-line \ ( bufaddr n )
    .s
    5 = if  \ ( bufaddr )
      1 nlines +!
      5 0 do
        dup i + c@ 49 = if  ( bufaddr -- )
          1 cnt i cells + +!
        then
      loop drop
    then
  ffl-repeat

  0 \ gamma
  5 0 do
    2* \ shift gamma left
    cnt i cells + @
    nlines @ 2/
    > if
      1+
    then
  loop

  dup invert 31 and *
  ;


T{ s" tinput.txt" part1 }T{ 198 }T
\ ." PART1: " s" input.txt" part1 . cr
