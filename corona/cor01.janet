

(defn sequences [ns]
  (def sqs @[@[]])
  (var last-n -1)
  (loop [n :in ns]
    (when (or (<= n last-n)
              (= (% n 2) (% last-n 2)))
      (array/push sqs @[]))
    (set last-n n)
    (array/push (last sqs) n))
  sqs)

(assert (deep= (sequences [1 2 3 4 1 2 3]) @[@[1 2 3 4] @[1 2 3]]))
(assert (deep= (sequences [1 2 4 7 1 2 3]) @[@[1 2] @[4 7] @[1 2 3]]))

(defn part1 [ns]
  (length
    (extreme
      (fn [a b] (> (length a) (length b)))
      (sequences ns))))

(def data
  (->>
      (slurp "inp01.txt")
      (string/trimr)
      (string/split " ")
      (map scan-number)))

(assert (= 3 (part1 [1 2 4 7 1 2 3])))
(printf "PART1: %d" (part1 data))

(defn part2 [ns]
  (var lastn -1)
  (def sq @[])
  (each n (sort (array/slice ns))
    (when (and (not= lastn n) (not= (% lastn 2) (% n 2)))
      (array/push sq n))
    (set lastn n))
  [(length sq) sq])

(assert (= 2 (first (part2 [8 8 8 5 5 3]))))
(printf "PART2: %d" (first (part2 data)))

