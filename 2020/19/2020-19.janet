
(defn parse-rules (txt)
  (peg/match
    '{
      :cmd (* :d+ ":" :seqs)
      :seqs (+ :seq :or)
      :seq (some (* " " :d+))
      :or (* :seq "|" :seq)
      :main (some :cmd)}
    txt))

(def tds ```
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"```)

(def peg
  '{
    :main (* :1 :2)
    :1 "a"
    :2 (+ (* :1 :3) (* :3 :1))
    :3 "b"})

(pp (peg/match peg "aab"))
(pp (peg/match peg "aba"))
(pp (peg/match peg "abb"))

(pp (parse-rules tds))


