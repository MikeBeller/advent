(defn parse-input [s]
    (seq [ln :in (string/split "\n" (string/trim s))]
        (def f (string/split "   " ln))
        (map scan-number f)))

(def tinput (parse-input (slurp "tinput.txt")))
(def input (parse-input (slurp "input.txt")))

(defn part1 [inp]
    (def l1 (sort (map |(get $ 0) inp)))
    (def l2 (sort (map |(get $ 1) inp)))
    (sum
        (map |(math/abs (- $0 $1)) l1 l2)))

(assert (= 11 (part1 tinput)))
(print (part1 input))

(defn part2 [inp]
    (def l2d (frequencies (map |(get $ 1) inp)))
    (sum
        (map |(* $ (get l2d $ 0))
          (map |(get $ 0) inp))))

(assert (= 31 (part2 tinput)))
(print (part2 input))
