(alloc 1 15000)

(de assert exprs 
  (unless (eval (car exprs))
    (print (or (eval (cdr exprs)) 'assert))
    (stop t))
  'assert-ok
  )

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
(setq **xdiv** 1)
(setq **ydiv** (* **mod** **xdiv**))
(setq **x2div** (* **mod** **ydiv**))
(setq **y2div** (* **mod** **x2div**))

(de new-poly (x1 y1 x2 y2   poly ns n)
  (setq poly 0)
  (setq ns (list y2 x2 y1 x1))
  (while (setq n (pop ns))
    (setq poly (+ n (* poly **mod**))))
  poly)

(de poly-x1 (poly) (% (/ poly **xdiv**) **mod**))
(de poly-y1 (poly) (% (/ poly **ydiv**) **mod**))
(de poly-x2 (poly) (% (/ poly **x2div**) **mod**))
(de poly-y2 (poly) (% (/ poly **y2div**) **mod**))

(assert
  (progn 
    (setq *p* (new-poly 1 2 3 4))
    (and 
      (equal 1 (poly-x1 *p*))
      (equal 2 (poly-y1 *p*))
      (equal 3 (poly-x2 *p*))
      (equal 4 (poly-y2 *p*))
    ) ) )

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
  (new-poly x y (+ x w) (+ y h))
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
  (setq ox1 (max (poly-x1 a) (poly-x1 b)))
  (setq ox2 (min (poly-x2 a) (poly-x2 b)))
  (setq oy1 (max (poly-y1 a) (poly-y1 b)))
  (setq oy2 (min (poly-y2 a) (poly-y2 b)))
  (if (or (le (- ox2 ox1) 0) (le (- oy2 oy1) 0))
    nil
    (new-poly ox1 ox2 oy1 oy2)))

(de zero-grid (   p)
  (setq p alloc)
  (reptn 10000 
    (@ p 0)
    (inc p) ) )

(de le (a b) (not (lessp b a)))
(de gt (a b) (lessp b a))
(de ge (a b) (not (lessp a b)))

(de safe-@ (p n) 
  (when (and (lessp p 1000) (lessp n 256)) (@ p n))
)

(de blit-grid (ymin a   x1 x2 y1 y2 x y p mxp)
  (setq p alloc)
  (setq x1 (poly-x1 a))
  (setq x2 (poly-x2 a))
  (setq y1 (- (poly-y1 a) ymin))
  (setq y2 (- (poly-y2 a) ymin))
  (setq x x1)
  (setq mxp 0)
  (while (lessp x x2)
    (setq y y1)
    (while (lessp y y2)
      (setq p (+ (* y 1000) x))
      (when (gt p mxp)
        (setq mxp p)
      )
      (safe-@ p (1+ (@ p)))
      (inc y))
    (inc x))
  (when (not (zerop mxp)) (print mxp))
)
  
(de count-grid-overlap ( p n)
  (setq n 0)
  (setq p alloc)
  (reptn 10000 
    (when (gt (@ p) 1)  (inc n) )
    (inc p))
    n )

(de n-overlap (ymin polys     item poly overlap)
  (zero-grid)
  (setq grid-poly (new-poly 0 ymin 1000 (+ ymin 10)))
  (while (setq poly (pop polys))
    (when (setq overlap (get-overlap poly grid-poly))
      (blit-grid ymin overlap) ) )
  (count-grid-overlap))

(de part1 (items   ymin total-overlap)
  (setq total-overlap 0)
  (setq ymin 0)
  (reptn 100
    (gc)
    (print (list ymin total-overlap (mfree)))
    (setq total-overlap
      (+ total-overlap (n-overlap ymin items)))
    (setq ymin (+ ymin 10)))
  total-overlap)

(part1 **items**)

t

