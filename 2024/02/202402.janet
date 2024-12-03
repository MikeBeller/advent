(defn lines [s] (string/split "\n" (string/trim (slurp s))))
(def rs
  (seq [ln :in (lines "input.txt")]
    (seq [f :in (string/split " " ln)] (scan-number f))))
(defn valid [r]
  (def dr (map |(- $0 $1) (slice r 0 -2) (slice r 1)))
  (or
    (and (all |(>= $ 1) dr) (all |(<= $ 3) dr))
    (and (all |(<= $ -1) dr) (all |(>= $ -3) dr))))
    
(print (count identity (map valid rs)))

(defn hacked [r]
  (seq [i :range [0 (length r)]] (array/remove (array/slice r) i)))
(defn any-valid [r]
  (any? (map valid (hacked r))))
  
(print (count any-valid rs))