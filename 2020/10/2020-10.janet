
(def test-data [16 10 15 5 1 11 7 19 6 12 4])
(def test-data-2 [28 33 18 42 31 14 46 20 48 47 24 23 49 45 19 38 39 11 1 32 25 35 8 17 7 9 4 2 34 10 3])

(defn parse-data [inp]
  (seq [s :in (string/split "\n" inp)] (scan-number s)))

(defn part1 [data]
  (var p 0)
  (def diffs
    (seq [v :in (sorted data)]
               (def diff (- v p))
               (set p v)
               diff))
  (def f (frequencies diffs))
  (* (in f 1) (inc (in f 3))))

(defn part2 [data]
  (def sd (sorted data))
  (def js (flatten [[0] sd [(+ (last sd) 3)]]))
  (def ln (length js))
  (def ps (array/new-filled ln 0))
  (put ps (dec ln) 1)
  (loop [i :down-to [(- ln 2) 0]]
    (var j (inc i))
    (while (and (< j ln) (<= (- (in js j) (in js i)) 3))
      (put ps i (+ (in ps i) (in ps j)))
      (+= j 1)))
  (in ps 0))

(assert (= 35 (part1 test-data)))
(assert (= 220 (part1 test-data-2)))

(def data (parse-data (string/trim (slurp "input.txt"))))
(print "PART1: " (part1 data))

(assert (= 8 (part2 test-data)))
(assert (= 19208 (part2 test-data-2)))
(print "PART2: " (part2 data))

