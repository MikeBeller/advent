fyi cr

1000 constant maxnum
15 constant maxbits
maxbits 2+ constant maxbuf

create nums maxnum cells allot
variable n_nums
variable n_bits
variable fid
create linebuf maxbuf allot
create colcounts maxbits cells allot

: open-data-file ( addr u -- )
  r/o open-file abort" open-file"
  fid !
  ;

: read-data-line ( -- nread )
  linebuf maxbuf fid @ read-line throw drop ( nread )
  ;

: parse-num ( nread -- num )
  0 swap 0 do ( n )
    1 lshift
    linebuf i + c@
    49 = if
      1+
    then
  loop
  ;

: read-data ( name nameln --  )
  0 n_nums !
  0 n_bits !
  open-data-file
  begin
    read-data-line ( nbytes )
    dup n_bits @ > if
      dup n_bits !
    then ( nbytes )
    dup 3 > \ at least 3 bytes in line
  while
    parse-num
    nums n_nums @ cells + !
    1 n_nums +!
  repeat
  ;

: print-data ( -- )
  n_nums @ 0 ?do
    nums i cells + @ . cr
  loop
  ;

: bitset? ( n i - t/f )
  1 swap lshift and
  ;

9 3 bitset? 0= abort" bitset"
9 2 bitset? 0<> abort" bitset"

: column-counts ( -- )
  n_bits @ 0 do
    0
    n_nums @ 0 do ( count )
      nums i cells + @
      j bitset? if
        1+
      then
    loop ( count )
    colcounts n_bits @ i - 1- cells + !
  loop
;

: compute-gamma ( -- gamma )
  0
  n_bits @ 0 do
    2*
    colcounts i cells + @
    2*
    n_nums @ > if
      1+
    then
  loop
;

: compute-epsilon ( gam -- eps )
  invert
  1 n_bits @ lshift 1- and
;

: part1 ( addr u -- ans )
  read-data
  \ print-data
  column-counts
  compute-gamma dup . cr
  dup compute-epsilon dup . cr
  um*
;

s" tinput.txt" part1 198 s>d d= invert abort" part1"

s" input.txt" part1
." PART1:" d. cr

fyi

bye
