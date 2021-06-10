(defn parse-inst [line]
  (def [istr nstr] (string/split " " (string/trim line)))
  [(keyword istr) (scan-number nstr)])

(defn parse-data [inp]
  (->> inp
      (string/trim)
      (string/split "\n")
      (map parse-inst)))

(def test-input ```
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
```)

(def td (parse-data test-input))

(defn run [code]
  (var pc 0)
  (var acc 0)
  (def visited (array/new-filled (length code)))
  (forever
    (when (in visited pc) (break))
    (put visited pc true)
    (match (in code pc)
      [:nop n] (+= pc 1)
      [:acc n] (do
                 (+= pc 1)
                 (+= acc n))
      [:jmp n] (+= pc n)
      _ (eprint "bad inst")))
  acc)

(defn part1 [code]
  (run code))

(assert (= (part1 td) 5))

(def data (parse-data (slurp "input.txt")))
(print "PART1: " (part1 data))

