(alloc 1)

(de sym-to-codes (sym)
  (mapcar (unpack sym) 'ascii))

(de codes-to-sym (codes)
  (pack (mapcar codes 'char)))

(de readline (chan   cs c)
  (setq cs nil)
  (while t
    (setq c (getc chan))
    (when (or (equal c 26) (equal c 10) (equal c 13))
      (return
        (if (not cs) nil
          (codes-to-sym (reverse cs)) ) ))
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

[ (count (sym-to-codes (cadr **lines**))) ]

(de hasval (n alist)
    (while (setq p (pop alist))
           (when (equal n (cdr p)) (return t)))
    nil)

(de part1 (lines    twos threes line counts)
    (setq twos 0)
    (setq threes 0)
    (while (setq line (pop lines))
           (setq counts (count (sym-to-codes line)))
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

(stop (not (equal 3 (diff1 (sym-to-codes 'abcde) (sym-to-codes 'abxde)))))
(stop (diff1 (sym-to-codes 'abcde) (sym-to-codes 'abxye)))

[ return a copy of xs with nth (0-based) item removed ]
(de rem-nth (n xs   ys)
  (setq ys nil)
  (reptn n
    (push (pop xs) ys))
  (append (reverse ys) (cdr xs)))

(stop (not (equal (list 2 3 4 6) (rem-nth 3 (list 2 3 4 5 6)))))

(de part2 (lines   lx ly x y d)
  (setq lx lines)
  (while (and lx (setq x (sym-to-codes (pop lx))))
    (print x)
    (setq ly lx)
    (while (and ly (setq y (sym-to-codes (pop ly))))
      (when (setq d (diff1 x y))
        (return (codes-to-sym (rem-nth d y)))))))

(part2 **lines**)

t

