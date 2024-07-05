:- use_module(library(clpz)).
% :- use_module(library(debug)).
% this correctly shows tail recursion -- no memory increase
% wasn't able to get it to work where C0 was on the right -- why?

count(1,1,1).
count(N,N,N).
count(N,C0,R) :- C0 #< N, C #= C0 + 1, count(N,C,R).

main :- count(10000000,1,X), write(X), nl, halt.
:- initialization(main).
