:- use_module(library(lists)).
domain(h).
domain(m).
starting([h,h,h,h]).
goal([m,m,m,m]).
flip(h,m).
flip(m,h).

safe([F,H,C,X]) :- 
    domain(F), domain(H), domain(C), domain(X),
    (F \= H ; H = X), (H \= C ; H = X).

move([X,H,C,X], [NX,H,C,NX]) :- flip(X,NX).
move([F,X,C,X], [F,NX,C,NX]) :- flip(X,NX).
move([F,H,X,X], [F,H,NX,NX]) :- flip(X,NX).
move([F,H,C,X], [F,H,C,NX]) :- flip(X,NX).

path([G|Rest], Answer) :- goal(G), reverse(Answer, [G | Rest]).
path([S0|Rest], Path) :-
    move(S0, S1),
    safe(S1),
    \+ member(S1, [S0|Rest]),
    path([S1, S0|Rest], Path).

solve(P) :- starting(S), path([S], P).
main :- setof(Path, solve(Path), Paths), write(Paths), nl, halt.
:- initialization(main).
