(alloc 1)

(de readline (chan   cs c)
  (setq cs nil)
  (while t
    (setq c (getc chan))
    (when (or (equal c 26) (equal c 10) (equal c 13))
      (return
        (if (not cs) nil
        (pack (reverse (mapcar cs 'char))))))
    (push c cs)))

(de readlines (f    sym lines)
    (open f 0)
    (setq lines nil)
    (while (setq sym (readline 0))
      (push sym lines))
    (close 0)
    (reverse lines))

(length (setq **lines** (readlines '(T1802 TXT))))

(de chars (sym)
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

[ (count (chars (cadr **lines**))) ]

(de hasval (n alist)
    (while (setq p (pop alist))
           (when (equal n (cdr p)) (return t)))
    nil)

(de part1 (lines    twos threes line counts)
    (setq twos 0)
    (setq threes 0)
    (while (setq line (pop lines))
           (setq counts (count (chars line)))
           (when (hasval 2 counts) (inc twos))
           (when (hasval 3 counts) (inc threes)))
    (list twos threes (* twos threes)))

(part1 **lines**)



t

