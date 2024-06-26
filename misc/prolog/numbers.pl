:- use_module(library(pio)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).

read_integers(File, Integers) :-
    phrase_from_file(integer_list(Integers), File).

integer_list([I|Is]) --> optional_blanks, integer(I), optional_blanks, integer_list(Is) optional_blanks.
integer_list([]) --> [].

integer(I) --> sign('+'), digits(Ds), { maplist(char_code, Ds, Cs), number_codes(I, Cs) } .
integer(I) --> sign('-'), digits(Ds), { maplist(char_code, Ds, Cs), number_codes(I, [45 | Cs]) } .

sign('-') --> "-", !.
sign('+') --> "+", !.

digits([D|Ds]) --> digit(D), digits(Ds).
digits([D]) --> [D].

digit(D) --> [D], { char_type(D, decimal_digit) }.

optional_blanks --> [C], { char_type(C, whitespace) }, optional_blanks.
optional_blanks --> [].

blanks --> [C], { char_type(C, whitespace) }, blanks.
blanks --> [C], { char_type(C, whitespace) }.

