/ ---- basic
til:{!x}

/ ---- aggregations
sum:(+/)
prd:(*/)
all:(&/)
any:(|/)
avg:{(+/x)%#x}
med:{(x@<x)@_(#x)%2}    / simple median; refine later if you need even-count mean
var:{(+/(_sqr x-avg x))%#x}
std:{_sqrt var x}
max:(|/)
min:(&/)

/ ---- selectors & shape
len:{#x}
first:{*x}
rest:{1_x}
rev:{|x}
flatten:{,/x}

/ ---- set & membership
uniq:{?x}
where:{&x}
grp:{=x}
count:{#'=x}

/ ---- take/drop/reshape
take:{x#y}
drop:{x_y}
reshape:{y#x}
flip:{+x}
dict:{x!y}
asc:{x@<x}
desc:{x@>x}

/ ---- arithmetic helpers
dot:{+/x*y}
unit:{x%\:_sqrt x dot x}
abs:{x|-x}

/ general adverbs
each:{x'y}
eachprior:{x':y}

/ conversion
int:{`I$x}
float:{`F$x}
sym:{`s$x}
type:{@x}
cast:{x$y}

/ ---- scans
cumsum:(+\)
cumprd:(*\)
cummin:(&\)
cummax:(|\)

/ ---- split / join / encode / decode (ngn/k)
split:{x\ y}        / dyad: e.g. "-" split "a-b-c"
join:{x/ y}         / dyad: e.g. "-" join ("a";"b";"c")
enc:{x/y}           / dyad: base-encode (left is radix vector or base)
dec:{x\y}           / dyad: base-decode

/ ---- string helpers (idioms)
ltrim:{x@&|\~x=" "}                         / delete leading blanks
rtrim:{|ltrim@|x}                             / delete trailing blanks
trim:{ltrim rtrim x}
lower:{_x}

/ --- io
lines:{0:x}
read:{1:x}

/ ---------- group-by over a key vector
by:{[k;v;f] g:= =k; (!g)!f' v@' g}
sumby:{[k;v] by[k;v;(+/)]}
avgby:{[k;v] by[k;v;{(+/x)%#x}]}
minby:{[k;v] by[k;v;(&/)]}
maxby:{[k;v] by[k;v;(|/)]}
countby:{[k] g:= =k; ks:!g; ks!#' g ks}

/ ---------- group-by over table t by one or more key columns
tby:{[t;ks;v;f] k:=,/' t ks; g:= =k; (!g)!f' (t v)@' g}
tsum:{[t;ks;v] tby[t;ks;v;(+/)]}
tavg:{[t;ks;v] tby[t;ks;v;{(+/x)%#x}]}
tmin:{[t;ks;v] tby[t;ks;v;(&/)]}
tmax:{[t;ks;v] tby[t;ks;v;(|/)]}
tcount:{[t;ks] k:=,/' t ks; g:= =k; ks:!g; ks!#' g ks}

/ ---------- table/dict conveniences (dict-of-columns “tables”)
withcol:{[t;s;v] t,s!v}
select:{[cs;t] +cs!(t@cs)}
keys:{!x}

/ ngn/k
ESC:  "\""    / escape
ROW:  "\n"    / row separator
FLD:  ","     / field separator

uq:{$[*q:x=ESC;-1_x@&~q&2!+\q;x]}          / unquote
sp:{[s;x](1&l)_'(l:0,&(2!+\x=ESC)<x=s)_x}  / split
csvorig:{uq''sp[FLD]'sp[ROW;x]}            / parse CSV

/ faster, but perhaps less elegant
csvnew:{m:=\~q:"\""=x:"\n",x
     d:m&/:",\n"=\:x
     f:1_/:(-/1((+\q)@)\&|/`b$d)_ :[;q:<\q]_x
     _[+/1(!#:)\(+\d 0)@&d 1;f]}

chomp:{c:-1#x; :[c[0]=10;-1_x;x]}

rcsv:{csvnew chomp (1:x)}
csv:{rows:rcsv[x]; + dict[`s$'*rows;+(1_rows)]}
/ ctype:{[c;tp;tb] tb[c]::cast[tp] tb[c]}
