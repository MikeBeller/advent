(alloc 1 10000)

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

(setq **mod** 1024)

(de poly-pack (x y h w   xs cookie)
  (setq cookie 0)
  (setq xs (list x y h w))
  (while (setq x (pop xs))
    (setq cookie (+ x (* cookie **mod**))))
  cookie)

(de poly-unpack (cookie  ls)
  (setq ls nil)
  (reptn 4
    (push (% cookie **mod**) ls)
    (setq cookie (/ cookie **mod**))
  )
  ls
)

(de poly-x (poly) (car poly) )
(de poly-y (poly) (cadr poly) )
(de poly-w (poly) (caddr poly) )
(de poly-h (poly) (caddr (cdr poly) ))

(de read-item (chan   x y w h line)
  (setq line (read-line chan))
  (unless line (return nil))
  (setq toks (split-by 'is-whitespace line))
  (setq toks (cddr toks))  [ drop 2 ]
  (setq p (split ', (car toks)))
  (setq x (str-to-num (car p)))
  (setq y (str-to-num (cadr p)))
  (setq p (split 'x (cadr toks)))
  (setq w (str-to-num (car p)))
  (setq h (str-to-num (cadr p)))
  (poly-pack x y w h)
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
  (close 0)
  (reverse items))

(gc)
(mfree)
(length (setq **items** (read-data)))
(gc)
(mfree)

[ what's left: 
 - define get-overlap to return the overlap poly 
   - requires adding poly-x2 and poly-y2
 - define blit-grid to blit a poly onto the grid (adjusting for xmin)
   - 'blit' by incrementing the byte -- ignore possibility of numeric overflow
 - Optimization -- can sort the items by x1 and by x2, and for each band,
     only work with polygons that intersect that band
]
(de get-overlap (a b   ox1 ox2 oy1 oy2)
  
)

(de zero-grid (   p)
  (setq p alloc)
  (reptn 10000 
    (@ p 0)
    (inc p) ) )
  
(de count-grid-overlap ( p n)
  (setq n 0)
  (setq p alloc)
  (reptn 10000 
    (when (lessp 1 (@ p))  (inc n) ))
    n )

(de n-overlap (xmin items     item poly overlap)
  (zero-grid)
  (setq grid-poly (list xmin 0 1000 10))
  (while (setq item (pop items))
    (setq poly (poly-unpack item))
    (when (setq overlap (get-overlap item grid-poly))
      (blit-grid xmin overlap) ) )
  (count-grid-overlap))

(de part1 (items   xmin total-overlap)
  (setq total-overlap 0)
  (setq xmin 0)
  (reptn 100
    (setq total-overlap
      (+ total-overlap (n-overlap xmin items)))
    (setq xmin (+ xmin 10)))
  total-overlap)


t

