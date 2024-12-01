(defn parse-input [s]
    (def ps (seq [ln :in (string/split "\n" (string/trim s))]
        (def f (string/split "   " ln))
        (map scan-number f)))
    (tuple (map |(get $ 0) ps) (map |(get $ 1) ps)))
(def tinput (parse-input (slurp "tinput.txt")))
(def input (parse-input (slurp "input.txt")))

(defn part1 [[aa bb]]
    (sum (map |(math/abs (- $0 $1)) (sort aa) (sort bb))))
(assert (= 11 (part1 tinput)))
(print (part1 input))

(defn part2 [[aa bb]]
    (def bd (frequencies bb))
    (sum (map |(* $ (get bd $ 0)) aa)))
(assert (= 31 (part2 tinput)))
(print (part2 input))
