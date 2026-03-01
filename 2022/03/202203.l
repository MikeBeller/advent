# Logica
@Engine("sqlite");
NewLine() = SqlExpr("char(10)", {});
Instr(s,x) = SqlExpr("instr({s},{x})", {s: s, x: x});
@Ground("Inp");
Lines(line) :- line in Split(ReadFile("input.txt"), NewLine());
Encode(line, xs) :- 
  xs == List{x :-
            i in Range(Length(line)),
            x == Instr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", Substr(line,i+1,1))};
Inp(x) :- Lines(line), Encode(line, x);
Hs(l,r) :- Inp(x), ln == Size(x)/2,
   l == Set{y :- i in Range(ln), y == Element(x,i)},
   r == Set{y :- i in Range(ln), y == Element(x,i+ln)};
