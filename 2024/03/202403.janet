(def input (slurp "input.txt"))
(def ps
  (peg/match ~{
    :num (<- :d+)
    :mul (group (* "mul(" :num "," :num ")"))
    :do (/ "do()" :do)
    :dont (/ "don't()" :dont)
    :main (some (thru (+ :mul :do :dont)))} input))
(print (sum (seq [p :in ps :when (array? p)]
  (* (scan-number (get p 0)) (scan-number (get p 1))))))

(var en 1)
(def r
  (sum
    (seq [p :in ps]
      (match p
        :do (do (set en 1) 0)
        :dont (do (set en 0) 0)
        [a b] (* en (scan-number a) (scan-number b))))))
(print r)