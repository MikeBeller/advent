:- use_module(library(pio)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(lists)).

read_integers(File, Integers) :-
    once(phrase_from_file(integer_list(Integers), File)).

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

