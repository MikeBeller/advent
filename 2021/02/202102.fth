include  ../fth/advent2021.fth

variable pos
variable dep

: do-line ( xt n -- ) swap .s execute ;

: do-forward ( n -- ) pos +! ;
: do-down ( n -- ) dep +! ;
: do-up ( n -- ) negate dep +! ;

: forward ['] do-forward ;
: down ['] do-down ;
: up ['] do-up ;

T{ forward 5 do-line pos @ }T{ 5 }T

: part1 ( addr u -- u )
    2dup type
    ['] do-line foreach-file-line
    pos @ dep @ *
    ;

 s" input.txt" part1 . cr
