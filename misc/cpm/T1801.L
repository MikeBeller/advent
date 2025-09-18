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

(setq nums nil)
(open '(T1801 TXT) 0)
(while (setq n (readnum 0))
   (push n nums))
(setq nums (reverse nums))
(close 0)

(de part1 (nums [loc:]  sm n)
    (setq sm 0)
    (while (setq n (pop nums))
           (setq sm (+ sm n)))
    sm)

(setq delta (part1 nums))

(de part2 (nums delta [loc:]   sm sums xs ys diff)
    (setq sm 0)
    (setq sums (list))
    (while nums
      (setq sm (+ sm (pop nums)))
      (push sm sums))
    (setq sums (reverse sums))
    (print sums)

    (setq xs sums)
    (while xs
      (setq x (car xs))
      (setq ys sums)
      (while ys
        (setq y (car ys))
        (setq diff (- x y))
        (when (and (lessp 0 diff) (zerop (% diff delta)))
          (print (list x y diff delta))
          (return (+ x (+ diff y))))
        (pop ys))
      (pop xs)))

(part2 nums delta)
t

