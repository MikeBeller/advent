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

[ returns an alist with count of each character in a symbol ]
(de (count ))
(de part1 (lines  counts)
  
)

t 
