(alloc 1)

(de assert exprs 
  (unless (eval (car exprs))
    (print (or (eval (cdr exprs)) 'assert))
    (stop t)))

(assert t 'noprinty)
[ (assert nil 'printy) ]

(setq **line** nil)

(de whitespace (c)
  (or (equal c 26) (equal c 10) (equal c 13) (equal c 32) (equal c 9)))

(de read-line (chan   c)
  (setq **line** nil)
  (while t
    (setq c (getc chan))
    (when (or (equal c 26) (equal c 10) (equal c 13))
      (setq **line** (reverse **line**))
      (return **line**))
    (push c **line**)))

[ Remove and return one whitespace delimited token from **line**
  Ignore leading and trailing whitespace. ]
(de get-token (   c tok)
  (setq tok nil)
  (while **line**
    (setq c (pop **line**))
    (if (whitespace c)
      (when tok (return (reverse tok))))
      (push c tok))
  (reverse tok))

[ if c represents an ascii decimal digit, return that digit, else return nil ]
(de digit (c)
  (and (lessp 47 c) (lessp c 58)))

[ convert string to num -- stop at first non-decimal digit 
  -- return  nil if no digits found ]
(de to-num (tok   c n d)
  (setq n nil)
  (while (setq c (pop tok))
    (unless (setq d (digit c))
      (return n))
    (setq n (if n (+ (* n 10)) 0)))
   n)

[ return a list of all decimal numbers in **line**, 
  treating all non decimal-digit characters as separators ]
(de get-nums (   tok nums)
  (setq nums nil)
  (while (setq tok (get-token))
    (print tok)
    (setq n (to-num tok))
    (print n)
    (when n 
      (push num nums)))
    (reverse nums))

(de read-item (chan   item)
  (read-line chan)
  (setq item (get-nums 0))
  (or (cdr nums) nil))

(open '(T1803 TXT) 0)
(read-item 0)
(close 0)

t 
