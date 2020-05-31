
(defn digit [d]
  (assert (and (>= d 48) (<= d 57)))
  (- d 48))

(defn parse-data [s nr nc]
  (def ll (* nr nc))
  (def nl (/ (length s) ll))
  (assert (= (math/floor nl) nl))
  (seq [l :range [0 nl]]
    (seq [r :range [0 nr]]
      (seq [c :range [0 nc]]
        (digit (s (+ (* l ll) (* r nc) c)))))))

(assert (deep= (parse-data "012120121201" 2 3)
               @[@[@[0 1 2] @[1 2 0]] @[@[1 2 1] @[2 0 1]]]))

(defn part-one [s nr nc]
  (def data (parse-data s nr nc))
  (def nl (length data))
  (def fr
    (seq [l :in data]
      (frequencies (flatten l))))
  (def mxli (extreme (fn [i j] (< ((fr i) 0) ((fr j) 0))) (range nl)))
  (def mxff (fr mxli))
  (* (mxff 1) (mxff 2)))

(assert (= 4 (part-one "012120121001" 2 3)))

(def [nr nc] [6 25])
(def datastr
  (string/trimr
    (with [f (file/open "input.txt")]
      (file/read f :all))))
(printf "PART1: %d" (part-one datastr nr nc))

(defn part-two [s nr nc]
  (def data (parse-data s nr nc))
  (def nl (length data))
  (def g (seq [r :range [0 nr]] (array/new nc)))
  (loop [r :range [0 nr]
         c :range [0 nc]]
    (loop [l :range [0 nl]]
      (def v (get-in data [l r c]))
      (when (not= v 2)
        (put-in g [r c] v)
        (break))))
  g)

(defn print-grid [g]
  (each row g
    (print
      (string/join (map |(if (= $ 0) " " "#") row)))))

(def ans2 (part-two datastr nr nc))
(print "PART2:")
(print-grid ans2)

