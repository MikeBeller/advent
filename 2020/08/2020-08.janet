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
  (def ln (length code))
  (var pc 0)
  (var acc 0)
  (def visited (array/new-filled (inc ln)))
  (put visited ln true)  # for part 2
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
  [acc pc])

(defn part1 [code]
  (def [acc pc] (run code))
  acc)

(defn tweak-inst [code pc]
  (def code (array/slice code))
  (match (in code pc)
    [:nop n] (put code pc [:jmp n])
    [:jmp n] (put code pc [:nop n]))
  code)

(defn part2 [code]
  (def ln (length code))
  (var ans nil)
  (loop [i :range [0 ln]]
    (def code (tweak-inst code i))
    (def [acc pc] (run code))
    (when (= pc ln)
      (set ans acc)
      (break)))
  ans)

(assert (= (part1 td) 5))

(def data (parse-data (slurp "input.txt")))
(print "PART1: " (part1 data))

(assert (= (part2 td) 8))
(print "PART2: " (part2 data))

