
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

(assert (deep= (cons 3 (cons 2 (cons 1 nil))) (list 3 2 1)))

# cup is of form [label [next-label next-cup]]
(defn cup/new [n nxl] (cons n (cons nxl nil)))
(defn cup/label [c] (car c))
(defn cup/next-label [c] (car (cdr c)))
(defn cup/next-cup [c] (cdr (cdr c)))
(defn cup/set-next-cup [c v] (setcdr (cdr c) v))

(defn cup/each [cups nxfunc func]
  (defn lp [p]
    (func p)
    (let [nx (nxfunc p)]
      (if (and (not (nil? nx)) (not= nx cups))
        (lp nx))))
  (lp cups))

(defn cup/print-cups [cups nxfunc]
  (prin "::")
  (cup/each cups nxfunc
            (fn [c] (do
                      (prin " ")
                      (prin (cup/label c)))))
  (print))

(defn cup/find-label [cups lb]
  (defn lp [c]
    (cond
      (nil? c) nil
      (= (cup/label c) lb) c
      (lp (cup/next-label c))))
  (lp cups))

# tests
(def tc (cup/new 3 (cup/new 2 (cup/new 1 nil))))
(assert (= 3 (cup/label tc)))
(assert (= 2 (cup/label (cup/next-label tc))))
(assert (= 1 (cup/label (cup/next-label (cup/next-label tc)))))
(assert (= nil (cup/next-label (cup/next-label (cup/next-label tc)))))
#(cup/print-cups tc cup/next-label)

# code
(defn next [cups cur]
  # pull out the 3 cups to right of cur
  (def n1 (cup/next-cup cur))
  (def n2 (cup/next-cup n1))
  (def n3 (cup/next-cup n2))
  (cup/set-next-cup cur (cup/next-cup n3))
  #(print "PICK UP" (cup/label n1) " " (cup/label n2) " " (cup/label n3))

  # find the destination cup 'dc' with next lower label number
  # skipping n1 n2 n3
  (defn lp [nx]
    (if
      (and (not= n1 nx) (not= n2 nx) (not= n3 nx)) nx
      (lp (or (cup/next-label nx) cups))))
  (def dc (lp (or (cup/next-label cur) cups)))

  # place n1,n2,n3 to the right of destination cup
  (def tmp (cup/next-cup dc))
  (cup/set-next-cup dc n1)
  (cup/set-next-cup n3 tmp)

  # return the new 'current' pointer
  (cup/next-cup cur))

(defn part1 [cs nmoves]
  # create a list of cup objects
  #  cup/label 1-9
  #  cup/next-label is pointer to cup with next lower label
  #  cup/next-cup is pointer to cup to the right in circle
  (defn lp [cs i ls]
    (if (nil? cs) ls
      (lp (cdr cs) (inc i) (cup/new i ls))))
  (def cups (lp cs 1 nil))

  # make the cdr of each number cell point to the number cell of the next label in cs
  (def cur (cup/find-label cups (car cs)))
  (defn lp [cs p]
    (if (nil? cs) (cup/set-next-cup p cur)
      (let [nxl (car cs)
            nx (cup/find-label cups nxl)]
        (cup/set-next-cup p nx)
        (lp (cdr cs) nx))))
  (lp (cdr cs) cur)

  # advance nmoves
  (defn lp [n cur]
    #(cup/print-cups cur cup/next-cup)
    (if (= n 0) cur
      (do
        (lp (dec n) (next cups cur)))))
  (def cur (lp nmoves cur))

  (cup/print-cups cur cup/next-cup)
  )

(part1 (list 3 8 9 1 2 5 4 6 7) 10)
(part1 (list 2 1 9 7 4 8 3 6 5) 100)

