
# primitive
(defn cons [a b] @[a b])

(defn car [a] (in a 0))
(defn cdr [a] (in a 1))
(defn caar [ls] (car (car ls)))
(defn cadr [ls] (car (cdr ls)))
(defn setcar [p v] (put p 0 v))
(defn setcdr [p v] (put p 1 v))

(defn list [& xs]
  (def xs (array ;xs))
  (defn lp [xs ls]
    (if (= (length xs) 0) ls
      (let [x (array/pop xs)]
        (lp xs (cons x ls)))))
  (lp xs nil))

# compound
(defn assoc [ls n]
  (cond
    (nil? ls) nil
    (= (caar ls) n) (car ls)
    (assoc (cdr ls) n)))

(assert (deep= (cons 3 (cons 2 (cons 1 nil))) (list 3 2 1)))

(defn reverse [xs]
  (defn lp [xs ls]
    (cond
      (nil? xs) ls
      (lp (cdr xs) (cons (car xs) ls))))
  (lp xs nil))

(assert (deep= (reverse (list 3 2 1)) (list 1 2 3)))

(defn pring [cur]
  (defn lp [p]
    (print (car p))
    (cond
      (= (cdr p) cur) nil
      (do
        (lp (cdr p)))))
  (lp cur))

(defn next
  ```
  nums is assoc list of [[3,nx] [9,nx] ...]
  cur is pointer to current assoc e.g. ->9,nx
  nm is pointer in nums to cur e.g. ->[9,nx]
  ```
  [nums cur nm]
  # grab 3 items to right of cur
  (def n1 (cdr cur))
  (def n2 (cdr n1))
  (def n3 (cdr n2))
  (setcdr cur (cdr n3))

  # find the cell nx in nums that has car one lower than (car cur)
  # as long as the cell is not n1, n2, or n3
  (defn lp [ns]
    (cond
      (and (not= n1 (car ns)) (not= n2 (car ns)) (not= n3 (car ns))) ns
      (lp (cond (nil? (cdr ns)) nums (cdr ns)))))
  (def nx (lp nm))

  # place n1,n2,n3 to the right of (car nx)

  # return nx, (car nx)
  # wait can't we just return nx and figure out cur?

  cur)

(defn part1 [cs nmoves]
  (var nums nil)
  (defn lp [cs i ls]
    (cond
      (nil? cs) ls
      (lp (cdr cs) (inc i) (cons (cons i nil) ls))))
  (def nums (reverse (lp cs 1 nil)))

  (def cur (assoc nums (car cs)))
  (defn lp [nums cs p]
    (cond
      (nil? cs) (setcdr p cur)
      (let [nx (assoc nums (car cs))]
        (setcdr p nx)
        (lp nums (cdr cs) nx))))
  (lp nums (cdr cs) cur)

  (defn lp [n cur]
    (cond
      (= n 0) nil
       (lp (dec n) (next nums cur))))
  (lp nmoves cur)
  (pring cur)

  )

(part1 (list 3 8 9 1 2 5 4 6 7) 10)

