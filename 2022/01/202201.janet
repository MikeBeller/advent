(defn parse-group [groupstr]
    (seq [s :in (string/split "\n" groupstr)]
        (scan-number (string/trim s))))

(defn read-data [fpath]
  (seq [gs :in (string/split "\n\n" (string/trim (slurp fpath)))]
      (parse-group gs)))

(var tinput (read-data "tinput.txt"))
(var input (read-data "input.txt"))

(defn elf-cals [data]
    (seq [g :in data] (sum g)))

(defn part1 [data]
    (max-of (elf-cals data)))

(assert (= (part1 tinput) 24000))
(print "PART1: " (part1 input))

(defn part2 [data]
    (->>
        (elf-cals data)
        (sorted)
        (reverse)
        (take 3)
        (sum)))

(assert (= (part2 tinput) 45000))
(print "PART2: " (part2 input))