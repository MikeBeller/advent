:- use_module(library(clpz)).
:- use_module(library(lists)).
:- use_module(library(debug)).

cltz(1,1).
cltz(N,M) :- (N mod 2) #= 0, M #= N // 2.
cltz(N,M) :- (N mod 2) #= 1, M #= 3 * N + 1.

cltzLen(1,1).
cltzLen(C,L) :-
    C #> 1,
    cltz(C,C0),
    cltzLen(C0,L0),
    L #= L0 + 1.

cltzMax(N, N, Mx, Mx).
cltzMax(C, N, Mx0, Mx) :-
	C #>= 1,
    cltzLen(C, L),
    Mx1 #= max(Mx0, L),
    C1 #= C + 1,
    $cltzMax(C1, N, Mx1, Mx).

main :- $cltzMax(1,3,1,Mx), write(Mx), nl, halt.

:- initialization(main).
