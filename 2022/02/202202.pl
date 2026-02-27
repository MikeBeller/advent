% rps.pl  (SWI-Prolog)  -- reads "input.txt" lines like:  A X

txa("A","rock").     txa("B","paper").    txa("C","scissors").
txb("X","rock").     txb("Y","paper").    txb("Z","scissors").

beats("rock","scissors").
beats("scissors","paper").
beats("paper","rock").

tscore("rock",1).    tscore("paper",2).   tscore("scissors",3).
rscore("lose",0).    rscore("draw",3).    rscore("win",6).

run(Total) :-
    setup_call_cleanup(
        open('input.txt', read, In),
        ( findall(N, score_from_stream(In, N), Ns),
          sumlist(Ns, Total)
        ),
        close(In)
    ).

score_from_stream(In, N) :-
    read_line_to_string(In, Line),
    Line \== end_of_file,
    split_string(Line, " \t", " \t", [CA, CB]),
    txa(CA, TA),
    txb(CB, TB),
    outcome(TA, TB, R),
    tscore(TB, TS),
    rscore(R, RS),
    N is TS + RS.

outcome(TA, TB, "draw") :- TA = TB.
outcome(TA, TB, "win")  :- beats(TB, TA).
outcome(TA, TB, "lose") :- beats(TA, TB).
