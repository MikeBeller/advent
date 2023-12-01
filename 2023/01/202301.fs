require ../../2021/fth/ttester.fs

create lines cell allot
"tinput1.txt" lines $[]slurp-file
\ lines $[].

: isdig {: c -- 1/0 :}
  c 48 >=
  c 57 <=
  and ;

  T{ 49 isdig -> -1 }T
  T{ 58 isdig -> 0 }T 

: fdig {: saddr slen -- n :}
 slen 0 ?do
   saddr i + c@
   dup isdig if leave then
   drop
 loop
 48 - ;

 T{ "pqr3stu8vwx" fdig -> 3 }T

: ldig {: saddr slen -- n :}
 slen 0 ?do
   saddr slen + i - 1 - c@
   dup isdig if leave then
   drop
 loop
 48 - ;

T{ "pqr3stu8vwx" ldig -> 8 }T

: digs {: saddr slen -- n :}
  saddr slen fdig 10 *
  saddr slen ldig + ;

T{ "pqr3stu8vwx" digs -> 38 }T

: digsum digs + ;

: part1
 0 lines `digsum $[]map ;

T{ part1 -> 142 }T

"input.txt" lines $[]slurp-file
part1 .

bye
