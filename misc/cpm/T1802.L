(alloc 1)

(de readline (chan   cs c)
  (setq cs nil)
  (while t
    (setq c (getc chan))
    (when (or (equal c 26) (equal c 10) (equal c 13))
      (return
        (if (not cs) nil
          (pack (mapcar cs 'char))
        )
      )
      (return (reverse cs)))
    (push c cs)))

(de readlines (f    sym lines)
    (open f 0)
    (setq lines nil)
    (while (setq sym (readline 0))
      (push sym lines))
    (close 0)
    (reverse lines))

(gc)
(print (mfree))
(length (setq **lines** (readlines '(T1802 TXT))))
(gc)
(print (mfree))

(de codes (sym)
  (mapcar (unpack sym) 'ascii))

[ returns an alist with count of each character in a symbol ]
(de count (xs    x counts p)
  (setq counts nil)
  (while (setq x (pop xs))
    (setq p (assoc x counts))
    (unless p 
      (setq p (cons x 0))
      (push p counts))
    (rplacd p (1+ (cdr p))))
   counts)

[ (count (codes (cadr **lines**))) ]

(de hasval (n alist)
    (while (setq p (pop alist))
           (when (equal n (cdr p)) (return t)))
    nil)

(de part1 (lines    twos threes line counts)
    (setq twos 0)
    (setq threes 0)
    (while (setq line (pop lines))
           (setq counts (count (codes line)))
           (when (hasval 2 counts) (inc twos))
           (when (hasval 3 counts) (inc threes)))
    (* twos threes))

(part1 **lines**)

[ return differing character index if two strings differ by exactly 1 character, else return nil ]
(de diff1 (xs ys   cc diffcount x y dindex)
  (setq cc 0)
  (setq diffcount 0)
  (while xs  [same length]
    (setq x (pop xs))
    (setq y (pop ys))
    (inc cc)
    (when (not (equal x y))
      (setq dindex cc)
      (inc diffcount)
      (unless (lessp diffcount 2)  (return nil))
    )
  )
  (if (equal diffcount 1) dindex nil)
)

(stop (not (equal 3 (diff1 (codes 'abcde) (codes 'abxde)))))
(stop (diff1 (codes 'abcde) (codes 'abxye)))

(de part2 (lines   lx ly x y d)
  (setq lx lines)
  (while (setq x (pop lx))
    (setq ly lx)
    (while (setq y (pop ly))
      (when (setq d (diff1 x y))
        (return (list x y d))))))

(part2 **lines**)

t

