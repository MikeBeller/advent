
(defn cons [a b] @[a b])
(defn car [a] (in a 0))
(defn cdr [a] (in a 1))
(defn arr [ls]
  (def r @[])
  (var l ls)
  (while (not (nil? l))
    (array/push r (car l))
    (set l (cdr l)))
  r)
(defn find [ls n]
  (cond
    (nil? ls) nil
    (= (car ls) n) ls
    (find (cdr ls) n)))

(assert (deep= (arr (cons 3 (cons 2 (cons 1 nil)))) @[3 2 1]))

(defn part1 [cs nmoves]
  (def ln (length cs))
  (var nums nil)
  (loop [i :range-to [1 ln]]
    (set nums (cons i nums)))
  (pp (arr nums))
  (pp (arr (find nums 3)))
  )

(part1 [3 8 9 1 2 5 4 6 7] 10)

