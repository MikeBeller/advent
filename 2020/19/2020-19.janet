
(defn to-seq [& as]
  ~(* ,;as))

(defn to-or [a b]
  ~(+ ,a ,b))

(defn parse-rules (txt)
  (def pm (peg/match
    ~{
      :line (* :num ":" :rule)
      :rule (+ :str :or :seq)
      :seq (cmt (some (* " " :num)) ,to-seq)
      :or (cmt (* :seq " |" :seq) ,to-or)
      :str (* :s+ :quote (<- :S) :quote )
      :quote `"`
      :num (cmt (<- :d+) ,keyword)
      :main (* :line (some (* :s+ :line)) -1)
      }
    txt))
  (def pg (table ;pm))
  (put pg :main '(* :0 -1))
  (table/to-struct pg))

(defn part1 (inp)
  (def [rulestr teststr] (string/split "\n\n" inp))
  (def pg (parse-rules rulestr))
  (count truthy?
         (seq [line :in (string/split "\n" teststr)]
           (peg/match pg line))))

(assert (= (part1 (slurp "test1.txt")) 2))

(print "PART1: " (part1 (slurp "input.txt")))

(defn struct-to-table [str] (table ;(mapcat identity (pairs str))))

(defn part2 (inp)
  (def [rulestr teststr] (string/split "\n\n" inp))
  (def pg1 (parse-rules rulestr))
  (pp pg1)
  (def pgt (struct-to-table pg1))
  (put pgt :8 '(some :42))
  (put pgt :11 '(* :42 (any :11) :31))
  (def pg (table/to-struct pgt))
  (pp pg)
  (count truthy?
         (seq [line :in (string/split "\n" teststr)]
           (def xx (peg/match pg line))
           (print line " " xx)
           (peg/match pg line))))

(print (part2 (slurp "test2.txt")))


