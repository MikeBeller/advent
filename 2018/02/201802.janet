
(defn read-input [fname]
  (with [fh (file/open fname)]
    (seq [line :iterate (file/read fh :line)]
      (string/trim line))))

(defn checksum [label]
  (def fr (frequencies label))
  @[(some |(= $ 2) fr) (some |(= $ 3) fr)])

(assert (= (tuple ;(checksum "foobaaar")) [true true]))
(assert (= (tuple ;(checksum "fobaaar")) [nil true]))

(defn part-one [data]
  (var twocount 0)
  (var threecount 0)
  (each d data
    (def [two three] (checksum d))
    (if two (++ twocount))
    (if three (++ threecount)))
  (* twocount threecount))

(def data (read-input "input.txt"))
(print (part-one data))

(defn part-two [data]
  (var ans nil)
  (for i 0 (length (get data 0))
    (def seen @{})
    (each id data
      (def w (string (string/slice id 0 i) (string/slice id (+ i 1))))
      (if (get seen w)
        (do (set ans w)
          (break))
      (put seen w true)))
    (if ans (break)))
  ans)

(assert (= "fgij" (part-two @["abcde" "fghij" "klmno" "pqrst" "fguij" "axcye" "wvxyz"])))

(print (part-two data))

