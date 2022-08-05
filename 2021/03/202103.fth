include  ../fth/advent2021.fth

constant max-bits 16
create cnt max-bits cells allot \ will hold count of 1's in each column

: part1 { fname flen | nlines half nbits gamma bufaddr buflen -- gamma*epsilon }
  \ set cnt[i] to number of 1 bits in column i
  fname flen foreach-file-line \ ( bufaddr buflen )
    -> buflen -> bufaddr
    nbits 0= if
      buflen -> nbits \ on first loop, set number of bits
      cnt nbits cells 0 fill
    then
    buflen nbits <> abort" invalid line width"
    1 +-> nlines
    nbits 0 do
      bufaddr i + c@ 49 = if
        1 cnt i cells + +!
      then
    loop
  ffl-repeat

  nbits 0 do
    cnt i cells + ? bl emit
  loop cr

  0 -> gamma
  nlines 2/ -> half
  nbits 0 do
    gamma 2* -> gamma
    cnt i cells + @
    half
    > if
      1 +-> gamma
    then
  loop

  gamma invert 31 and
  gamma *
  ;


\ T{ s" tinput.txt" part1 }T{ 198 }T
." PART1: " s" input.txt" part1 . cr
