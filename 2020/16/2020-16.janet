
(def td-string ```
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12```)


(defn read-data [inp]
  (def [rulestr mystr nbstr] (string/split "\n\n" (string/trim inp)))

  # read the rules
  (def rules @{})
  (loop [line :in (string/split "\n" rulestr)]
    (def m
      (peg/match '(* (<- :w+) ": " (<- :d+) "-" (<- :d+) " or " (<- :d+) "-" (<- :d+)) line))
    (put rules (first m) (drop 1 m)))

  # my ticket
  (def [title stuff] (string/split "\n" mystr))
  (def mine (map scan-number (string/split "," stuff)))

  # other tickets
  (def others
    (seq [line :in (string/split "\n" nbstr)
          :when (not (string/has-prefix? "nearby" line))]
      (map scan-number (string/split "," line))))

  [rules mine others])

(pp (read-data td-string))



