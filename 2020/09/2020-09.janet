(def test-data [35 20 15 25 47 40 62 55 65 95 102 117 150 182 127 219 299 277 309 576])

(defn is-sum? [xs i j m]
  (def xj (in xs j))
  (var found false)
  (loop [k :range [i j]
         :while (not found)]
    (def diff (- xj (in xs k)))
    (if (and (not= diff (in xs k)) (> (get m diff 0) 0))
      (set found true)))
  found)

(defn part1 [xs w]
  (def m (frequencies (array/slice xs 0 w)))
  (var found 0)
  (loop [i :range [0 (- (length xs) w)]
         :let [j (+ i w)
               xi (in xs i)
               xj (in xs j)]
         :while (= found 0)]
    (if (not (is-sum? xs i j m)) (set found (in xs j)))
    (put m xj (inc (get m xj 0)))
    (def dv (get m xi))
    (put m xi (if (= dv 1) nil (dec dv))))
  found)

(defn mxsum [xs i n]
  (var s (in xs i))
  (def ys @[s])
  (loop [j :range [(inc i) (length xs)]]
    (def y (in xs j))
    (+= s y)
    (array/push ys y)
    (if (>= s n) (break)))
  [s ys])

(defn part2 [xs n]
  (var found nil)
  (loop [i :range [0 (dec (length xs))]
         :while (nil? found)]
    (def [r ys] (mxsum xs i n))
    (if (= r n)
      (set found (+ (min ;ys) (max ;ys)))))
  found)

(assert (= 127 (part1 test-data 5)))
(def data (map scan-number (string/split "\n" (slurp "input.txt"))))
(def ans1 (part1 data 25))
(print "PART1: " ans1)

(assert (= 62 (part2 test-data 127)))
(print "PART2: " (part2 data ans1))

