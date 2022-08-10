include  ../fth/advent2021.fs

variable pos
variable dep

: parse-num parse-word >num ;

: forward ( n -- ) parse-num pos +! ;
: down ( n -- ) parse-num dep +! ;
: up ( n -- ) parse-num negate dep +! ;

T{ forward 5 pos @ -> 5 }T
T{ forward 7 pos @ -> 12 }T

: part1 ( addr u -- u )
    0 pos !
    0 dep !
    included \ named file addr/u is "executed"
    pos @ dep @ *
    ;

T{ s" tinput.txt" part1 -> 150 }T
." PART1: " s" input.txt" part1 . cr

variable aim

: forward ( n -- )
  parse-num dup pos +!  ( n -- )
  aim @ * dep +! ;
: down ( n -- ) parse-num aim +! ;
: up ( n -- ) parse-num negate aim +! ;

: part2 ( addr u -- u )
    0 pos !
    0 dep !
    0 aim !
    included
    pos @ dep @ *
    ;

T{ s" tinput.txt" part2 -> 900 }T
s" input.txt" part2
." PART2: " . cr

bye