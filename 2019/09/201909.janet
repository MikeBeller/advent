(import ./intcode :as intcode)

(defn part-one [prog]
  (intcode/run-with-input prog @[1]))
(defn part-two [prog]
  (intcode/run-with-input prog @[2]))

(def instr (string/trimr (slurp "input.txt")))
(def prog (intcode/scan-prog instr))
(printf "PART1: %V" ((part-one prog) 0))
(printf "PART2: %V" ((part-two prog) 0))

