:- use_module(library(pio)).
:- use_module(library(dcgs)).
:- use_module(library(clpz)).
:- use_module(library(charsio)).
:- use_module(library(lists)).

read_integers(F, Is) :-
    once(phrase_from_file(integer_list(Is), F)).

integer_list([I|Is]) --> blanks, integer(I), blanks, integer_list(Is), blanks.
integer_list([]) --> [].

integer(I) --> sign('+'), digits(Ds), { number_chars(I, Ds) } .
integer(I) --> sign('-'), digits(Ds), { number_chars(I, ['-' | Ds]) } .
integer(I) --> digits(Ds), { number_chars(I, Ds) } .

sign('-') --> "-", !.
sign('+') --> "+", !.

digits([D|Ds]) --> digit(D), digits(Ds).
digits([D]) --> digit(D).

digit(D) --> [D], { char_type(D, decimal_digit) }.

blanks --> [C], { char_type(C, whitespace) }, blanks.
blanks --> [].

part1(Integers, Part1) :- 
    sum_list(Integers, Part1).

copy_list(_, 0, []).
copy_list(L, N, Result) :-
    N #> 0,
    N1 #= N - 1,
    copy_list(L, N1, Acc),
    append(L, Acc, Result).

sum_until_repeat([],_,_,_) :- fail.

% sum_until_repeats(_, Seen, Answer, Answer) :-
%     memberchk(Answer, Seen),
%     sum_until_repeats(_, Seen, Answer, _).

% sum_until_repeats(Is, Seen, Acc, Answer) :-
%     sum_until_repeats([I | Is], Seen0, Acc0, Answer),
%     Acc = Acc0 + I,
%     Seen = [Acc | Seen0].

sum_until_repeats([H|T], CurrentSum, SeenSums, RepeatingSum) :-
    NewSum #= CurrentSum + H,
    (   member(NewSum, SeenSums)
    ->  RepeatingSum = NewSum
    ;   sum_until_repeats(T, NewSum, [NewSum|SeenSums], RepeatingSum)
    ).

part2(Integers, Answer) :-
  copy_list(Integers, 1000, Copies),
  sum_until_repeats(Copies, 0, [], Answer).
    
main :-
    read_integers("input.txt", Integers),
    part1(Integers, Part1), write(Part1), nl,
    once(part2(Integers, Part2)), write(Part2), nl,
    halt.
