# Logica
@Engine("duckdb");
NewLine() = SqlExpr("chr(10)",{});
Data(content:) :- `(read_text("input.txt"))`(content:);
Lines(lines) :- Data(content:), lines == Split(content, NewLine());
Instr(s,x) = SqlExpr("instr({s},{x})", {s: s, x: x});
@Ground("Inp");
Encode(line, xs) :- 
  xs == List{x :-
            i in Range(Length(line)),
            x == Instr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", Substr(line,i+1,1))};
Inp(x) :- Lines(lines), line in linesEncode(line, x);
Hs(l,r) :- Inp(x), ln == Size(x)/2,
   l == Set{y :- i in Range(ln), y == Element(x,i)},
   r == Set{y :- i in Range(ln), y == Element(x,i+ln)};
