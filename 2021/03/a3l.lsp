(alloc 2) [ max open file handles ]
(setq CHN 1)

[ some generally useful code -- should be a library ]
(progn [ suppress repl printing ]

(de test (cc err)
    (unless cc
        (print (list 'Test 'Error: err))
        (bdos 0)))

(de reduce (xs f st)
    (mapc xs '((x)
        (setq st (apply f (list st x)))))
    st)
(test (equal (reduce '(3 4 5) '+ 0) 12) 'reduce)

(de reduce2 (xs f)
    (reduce (cdr xs) f (car xs)))
(test (equal (reduce2 '(3 4 5) '*) 60) 'reduce2)

(de maxl (xs) (reduce2 xs 'max))

(de repint (n f [loc:] i)
    (setq i 0)
    (while (lessp i n)
        (apply f (list i))
        (inc i)))
(test (progn (setq tt 0) (repint 5 '((i) (setq tt (+ tt i)))) (equal tt 10)) 'repint)


(de lt (x y) (lessp x y))
(de gt (x y) (lessp y x))
(de le (x y) (not (lessp y x)))
(de ge (x y) (not (lessp x y)))
(de = (x y) (equal x y))
(test (equal t (lt 3 5)) 'lt)
(test (equal nil (lt 5 5)) 'lt2)
(test (equal nil (le 3 2)) 'le1)
(test (equal t (le 3 3)) 'le2)
(test (equal nil (le 4 3)) 'le3)

'adventlib)

[ code specific to advent 2021-03 ]

(progn

(de read-num (ch [loc:] res c done)
    (setq res 0)
    (until done
        (setq c (getc ch))
        (cond
            ((equal c 49) (setq res (1+ (2* res))))
            ((equal c 48) (setq res (2* res)))
            ((equal c 10) (setq done t))
            (t (progn (setq done t) (setq res -1))))
        )
    res)

(de read-data (fp [loc:] old-rad res ch n)
    [ (setq old-rad (radix 2)) ]
    (setq res nil)
    (setq ch (open fp CHN))
    (until (minusp n)
        (setq n (read-num ch))
        (unless (minusp n)
            (push n res)))
    [ (radix old-rad) ]
    (close ch)
    res)

(de get-bit (b n)
    (reptn b
        (setq n (2/ n)))
    (if (oddp n) 1 0))

(test (equal (get-bit 1 7) 1) 'get-bit-1)
(test (equal (get-bit 9 7) 0) 'get-bit-2)

(test (equal (maxl '(3 9 5 4)) 9) 'maxl)

(de nbits (x nb)
    (setq nb 0)
    (while (not (zerop x))
        (inc nb)
        (setq x (2/ x)))
    nb)
(test (equal 5 (nbits 29)) 'nbits)

(de column-counts (xs w [loc:] ccs bn x cc)
    (reptn w (push 0 ccs))
    (while xs
        (setq x (car xs))
        (setq bn (- w))
        (setq cc ccs)
        (reptn w
            (when (oddp x)
                (rplaca cc (1+ (car cc))))
            (setq cc (cdr cc))
            (setq x (2/ x)))
        (setq xs (cdr xs)))
    (reverse ccs)
    )

(test (equal '(3 2 1) (column-counts '(4 7 6) 3)) 'column-counts)

(de b2n (bs [loc:] n)
    (setq n 0)
    (mapc bs '((b) (setq n (+ (2* n) b))))
    n)

(test (equal 11 (b2n '(1 0 1 1))) 'b2n)

(de part1 (xs [loc:] width len ccs gam eps)
    (setq width (nbits (maxl xs)))
    (setq len (length xs))
    (setq ccs (column-counts xs width))
    (setq gam (mapcar ccs
        '((x) (if (ge (2* x) len) 1 0))))
    (setq eps (mapcar gam '((x) (- 1 x))))
    (* (b2n gam) (b2n eps))
    )

(setq tinput (read-data '(tinput txt)))
(test (equal 198 (part1 tinput)) 'part1)

(setq input (read-data '(input txt)))

(prin1 'PART1:)
(print (part1 input))

(de part1 (xs [loc:] width len ccs gam eps)
    (setq width (nbits (maxl xs)))
    (setq len (length xs))
    (setq ccs (column-counts xs width))
    )

t)

(bdos 0)
