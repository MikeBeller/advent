:- use_module(library(pio)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).


read_integers(File, Integers) :-
    phrase_from_file(integer_list(Integers), File).

integer_list([I|Is]) --> integer(I), blanks, integer_list(Is).
integer_list([]) --> [].


integer(I) --> minus_sign(N), digits(D), { number_codes(I, [N|D]) }.
integer(I) --> digits(D), { number_codes(I, D) }.

minus_sign('-') --> "-", !.
minus_sign('') --> [].

digits([D|Ds]) --> digit(D), digits(Ds).
digits([]) --> [].

digit(D) --> [D], { char_type(D, decimal_digit) }.

blanks --> [C], { char_type(C, whitespace) }, blanks.
blanks --> [].
