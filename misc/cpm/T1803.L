(alloc 1)

(de assert exprs 
  (unless (eval (car exprs))
    (print (or (eval (cdr exprs)) 'assert))
    (stop t))
  'assert-ok
  )

(assert t 'noprinty)
[ (assert nil 'printy) ]

(de sym-to-str (sym)
  (mapcar (unpack sym) 'ascii))

(de str-to-sym (codes)
  (pack (mapcar codes 'char)))

(de is-whitespace (c)
  (or (equal c 26) (equal c 10) (equal c 13) (equal c 32) (equal c 9)))

(de read-line (chan   c line )
  (setq line nil)
  (while t
    (setq c (getc chan))
    (when (or (equal c 26) (equal c 10) (equal c 13))
      (setq line (reverse line))
      (return line))
    (push c line)))

[ if c represents an ascii decimal digit, return that digit, else return nil ]
(de digit (c)
  (and (lessp 47 c) (lessp c 58) (- c 48)))

(assert (not (digit 33)) 'digit1)
(assert (not (digit 58)) 'digit2)
(assert (equal 7 (digit 55)) 'digit3)

[ convert string to num -- stop at first non-decimal digit 
  -- return  nil if no digits found ]
(de str-to-num (tok   c n d)
  (setq n nil)
  (while (setq c (pop tok))
    (unless (setq d (digit c))
      (return n))
    (setq n (if n (+ (* n 10) d) d)))
   n)

(assert (equal 123 (str-to-num '(49 50 51))) 'str-to-num)
(assert (equal 123 (str-to-num '(49 50 51 65))) 'str-to-num)

(de split-by (pred cs  c items item)
  (setq items nil)
  (setq item nil)
  (while (setq c (pop cs))
    (if (apply pred (list c))
      (when item
        (push (reverse item) items)
        (setq item nil))
      (push c item)))
  (when item (push (reverse item) items))
  (reverse items))


(setq str (sym-to-str 'ABCXEF))
(assert (equal (split-by '((c) (equal c (ascii 'X))) str) '((65 66 67) (69 70))))

(de split (sym str   sep c)
  (setq sep (ascii sym))
  (split-by (list (list 'c) (list 'equal 'c sep )) str))

(assert (equal (split 'X str) (list (sym-to-str 'ABC) (sym-to-str 'EF))) 'split )

(de print-str (str)
  (mapc str 'putc)
  (cr))

(de read-item (chan   item line)
  (setq line (read-line chan))
  (unless line (return nil))
  (setq item nil)
  (setq toks (split-by 'is-whitespace line))
  (setq toks (cddr toks))  [ drop 2 ]
  (setq p (split ', (car toks)))
  (push (str-to-num (car p)) item)
  (push (str-to-num (cadr p)) item)
  (setq p (split 'x (cadr toks)))
  (push (str-to-num (car p)) item)
  (push (str-to-num (cadr p)) item)
  (reverse item)
)

(de read-data  (   items i)
  (open '(T1803 TXT) 0)
  (setq items nil)
  (setq i 0)
  (while (setq item (read-item 0))
    (push item items)
    (inc i)
    (when (zerop (% i 100)) (gc) (print (list i (mfree))))
  )
  (reverse items)
  (close 0))

(gc)
(mfree)
(setq **items** (read-data))
(gc)
(mfree)
t 
