(defn read-data [fpath]
  (string/split "\n" (string/trim (slurp fpath))))

(def tinput (read-data "tinput.txt"))
(def input (read-data "input.txt"))

(defn common
  "return the common characters between a and b using a table"
  [a b]
  (def t (frequencies a))
  (seq [c :in b
        :when (get t c)] c))

(defn score
  "score the character c as 1-26 for a-z and 27-52 for A-Z"
  [c]
  (if (<= 97 c 122) (- c 96) (- c 38)))

(defn part1 [data]
  (sum (seq [line :in data
             :let [ln (/ (length line) 2)
                   a (string/slice line 0 ln)
                   b (string/slice line ln)
                   c (common a b)]]
         (score (first c)))))

(assert (= 157 (part1 tinput)))
(print "PART1: " (part1 input))

(defn part2 [data]
  (def groups (partition 3 data))
  (sum
    (seq [[a b c] :in groups
          :let [cm (common (common a b) c)]]
      (score (first cm)))))

(assert (= 70 (part2 tinput)))
(print "PART2: " (part2 input))
