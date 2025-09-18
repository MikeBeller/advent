(alloc 1)

(de isdigit (d)
  (setq d (- d 48))
  (and (not (minusp d)) (lessp d 10)))

(de getc-nows (chan  c) 
  (setq c (getc chan))
  (while (or (equal c 32) (equal c 10))
    (setq c (getc chan)))
  c)

( de readnum (chan   c n sgn)
  (setq n 0)
  (setq sgn 0)
  (setq c (getc-nows chan))
  (cond
    ((equal c 43) (setq sgn 1))
    ((equal c 45) (setq sgn -1))
    (t (return nil))
  )
  (while t 
    (setq c (getc chan))
    (if (not (isdigit c)) (return (* sgn n))
      (setq n (+ (* n 10) (- c 48))))
  )
)

(de part1 (  sm n)
    (open '(T1801 TXT) 0)
    (setq sm 0)
    (while (setq n (readnum 0))
           (print n)
           (setq sm (+ sm n)))
    (print sm)
    (close 0))

(part1)

[ this blows out all memory on 64k z80 -- need better algorithm? ]
(de part2 (   n sm nums ns sums)
    (open '(T1801 TXT) 0)
    (while (setq n (readnum 0))
           (setq nums (cons n nums)))
    (setq nums (reverse nums))
    
    (setq sm 0)
    (setq sums (list))
    (setq ns nums)
    (while (not (member sm sums))
      (push sm sums)
      (when (not ns) (print (mfree)) (setq ns nums))
      (setq n (pop ns))
      (setq sm (+ sm n)))
    (print sm)
)

(part2)
t

