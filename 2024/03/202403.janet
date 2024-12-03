(def input (slurp "tinput.txt"))
(def ps
  (peg/match '(some (group
      (thru (* "mul(" (<- :d+) "," (<- :d+) ")")))) input))
(print (sum (seq [[a b] :in ps]
  (* (scan-number a) (scan-number b)))))