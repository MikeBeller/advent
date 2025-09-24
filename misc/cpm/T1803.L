(alloc 1)

(de assert exprs 
  (unless (eval (car exprs))
    (print (or (eval (cdr exprs)) 'assert))
    (stop t)))

(assert t 'noprinty)
[ (assert nil 'printy) ]

(de sym-to-codes (sym)
  (mapcar (unpack sym) 'ascii))

(de codes-to-sym (codes)
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
(de to-num (tok   c n d)
  (setq n nil)
  (while (setq c (pop tok))
    (unless (setq d (digit c))
      (return n))
    (setq n (if n (+ (* n 10) d) d)))
   n)

(assert (equal 123 (to-num '(49 50 51))) 'to-num)
(assert (equal 123 (to-num '(49 50 51 65))) 'to-num)

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

(setq str (sym-to-codes 'ABCXEF))
(print (split-by '((c) (equal c (ascii 'X))) str))

(de read-item (chan   item line)
  (setq line (read-line chan))
  (setq item nil)
  (setq toks (split-by 'is-whitespace line))
  (print toks))

(open '(T1803 TXT) 0)
(read-item 0)
(close 0)

t 
