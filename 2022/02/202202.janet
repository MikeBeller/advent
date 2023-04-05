(defn parse-input [s]
    (seq [line :in (string/split "\n" (string/trimr s))]
        (tuple/slice (string/split " " (string/trim line)))
    ))

(def tinput (parse-input (slurp "tinput.txt")))
(def input (parse-input (slurp "input.txt")))

(defn score [a b]
    (assert (keyword? a) "A")
    (assert (keyword? b) "B")
    (case b
        :R (+ 1 ({:R 3 :P 0 :S 6} a))
        :P (+ 2 ({:R 6 :P 3 :S 0} a))
        :S (+ 3 ({:R 0 :P 6 :S 3} a))))

(assert (= 8 (score :R :P)))
(assert (= 1 (score :P :R)))
(assert (= 6 (score :S :S)))

(defn part1 (data)
    (def guide {"A" :R "B" :P "C" :S "X" :R "Y" :P "Z" :S})
    (sum
        (seq
            [[a b] :in data]
                (score (guide a) (guide b)))))

(assert (= 15 (part1 tinput)))
(printf "PART1: %d" (part1 input))

(defn part2 (data)
    (defn guide [ol yl]
        (def opp ({"A" :R "B" :P "C" :S} ol))
        (def you 
            (case opp 
                :R ({"X" :S "Y" :R "Z" :P} yl)
                :P ({"X" :R "Y" :P "Z" :S} yl)
                :S ({"X" :P "Y" :S "Z" :R} yl)))
        [opp you])
    (sum
        (seq [[ol yl] :in data]
            (score ;(guide ol yl)))))

(assert (= 12 (part2 tinput)))
(printf "PART2: %d" (part2 input))