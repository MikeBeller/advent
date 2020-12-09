
(defn part1 [data]
  (def ln (length data))
  (def pairs
    (generate
        [i :range [0 (dec ln)]
         j :range [(inc i) ln]]
         [(in data i) (in data j)]))
  (var ans nil)
  (loop [[a b] :generate pairs]
    (if (= (+ a b) 2020)
      (do
        (set ans (* a b))
        (break))))
  ans)

(def td [1721 979 366 299 675 1456])
(assert (= (part1 td) 514579))

(def data (->>
    (slurp "input.txt")
    (string/trim)
    (string/split "\n")
    (map scan-number)))
(print "PART1: " (part1 data))

(defn part2 [data]
  (def ln (length data))
  (def triples
    (generate
        [i :range [0 (- ln 2)]
         j :range [(+ i 1) (- ln 1)]
         k :range [(+ i 2) ln]]
         [(in data i) (in data j) (in data k)]))
  (var ans nil)
  (loop [[a b c] :generate triples]
    (if (= (+ a b c) 2020)
      (do
        (set ans (* a b c))
        (break))))
  ans)

(assert (= (part2 td) 241861950))
(print "PART2: " (part2 data))

