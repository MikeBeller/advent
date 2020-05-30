
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

(assert (deep= (parse-data "012120121001" 2 3)
               @[@[@[0 1 2] @[1 2 0]] @[@[1 2 1] @[0 0 1]]]))

(defn part-one [s nr nc]
  (def d (parse-data s nr nc))
  (def fr
    (seq [l :in d]
      (frequencies (flatten l))))
  # change so it returns the index of the layer by converging the above lines
  # with this one
  (def mxl (extreme (fn [a b] (> (a 0) (b 0))) fr))
  (pp mxl))

(pp (part-one "012120121001" 2 3))

