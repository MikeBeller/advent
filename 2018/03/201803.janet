
(defn parse-line [line]
  (def strs (peg/match
             '(* "#" (<- :d+) " @ " (<- :d+) "," (<- :d+) ": " (<- :d+) "x" (<- :d+))
             line))
  (assert (= (length strs) 5))
  (def [id x y w h] (map scan-number strs))
  {:id id :x x :y y :w w :h h}
  )

(assert (= (parse-line "#1 @ 604,670: 22x16")
           {:x 604 :w 22 :y 670 :h 16 :id 1}))

(defn read-input [fname]
  (with [fh (file/open fname)]
    (seq [line :iterate (file/read fh :line)]
      (parse-line line))))

#(pp (read-input "input.txt"))

(def test-one
  (map parse-line
       ["#1 @ 1,3: 4x4" "#2 @ 3,1: 4x4" "#3 @ 5,5: 2x2"]))

(defn nrc [data]
  [ (+ 1 (max ;(map |(+ ($ :y) ($ :h)) data)))
    (+ 1 (max ;(map |(+ ($ :x) ($ :w)) data))) ])

# "slow" version using tables
(defn part-one-table [data]
  (gcsetinterval 100000000)
  (def [nr nc] (nrc data))
  (def sqs @{})
  (each {:x x :y y :w w :h h} data
    (for r y (+ y h)
      (for c x (+ x w)
        (def k (string r "," c))
        #(def k (+ (* r nc) c))
        (put sqs k (+ 1 (get sqs k 0))))))
  (count |(> $ 1) (values sqs))
  )

# fast version using typed arrays -- 400 times faster!
(defn part-one [data]
  (def [nr nc] (nrc data))
  (var count 0)
  (def sqs (tarray/new :int32 (* nr nc)))
  (each {:x x :y y :w w :h h} data
    (for r y (+ y h)
      (for c x (+ x w)
        (def i (+ (* r nc) c))
        (def n (+ (sqs i) 1))
        (if (= n 2)
          (++ count))
        (put sqs i n))))
  count)

(assert (= 4 (part-one-table test-one)))
(assert (= 4 (part-one test-one)))


(defn part-two [data]
  (def [nr nc] (nrc data))
  (def sqs (tarray/new :int32 (* nr nc)))
  (var ans nil)
  (each {:x x :y y :w w :h h} data
    (for r y (+ y h)
      (for c x (+ x w)
        (def i (+ (* r nc) c))
        (put sqs i (+ (sqs i) 1)))))
  (each {:id id :x x :y y :w w :h h} data
    (set ans id)
    (if
      (all |(= $ 1)
        (seq [r :range [y (+ y h)]
              c :range [x (+ x w)]
              :let [i (+ (* r nc) c)]]
          (get sqs i 0)))
      (break)))
  ans)

(def data (read-input "input.txt"))
#(print (part-one-table data))
(print (part-one data))
(print (part-two data))
