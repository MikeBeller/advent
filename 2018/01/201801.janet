
(defn read-input [fname]
  (with [fh (file/open fname)]
    (seq [line :iterate (file/read fh :line)]
      (scan-number (string/trim line)))))


(defn part-one [data]
  (sum data))

(defn part-two [data]
  (var s 0)
  (var seen @{})
  (while (not (get seen s false))
    (each d data
      (put seen s true)
      (+= s d)
      (if (get seen s false) (break))))
  s)

(assert (= 10 (part-two @[3 3 4 -2 -4])))

(def data (read-input "input.txt"))
(print "PART1: " (part-one data))
(print "PART2: " (part-two data))

