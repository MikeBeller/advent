(defn lines [s] (string/split "\n" (string/trim (slurp s))))
(def rs
  (seq [ln :in (lines "tinput.txt")]
    (seq [f :in (string/split " " ln)]
      (scan-number f))))

(defn valid [r]
  (def dr (diff r))
  (or
    (and (all |(>= $ 1) dr) (all |(<= $ 3) dr))
    (and (all |(<= $ -1) dr) (all |(>= $ -3) dr))))

(pp
  (seq [r :in rs]
    (valid r)))