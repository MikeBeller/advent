(import ./intcode :as intcode)

(defn part-one [prog]
  (intcode/run-with-input prog @[1]))

(def instr (string/trimr (slurp "input.txt")))
(def prog (intcode/scan-prog instr))
(pp (part-one prog))

