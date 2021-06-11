(defn parse-mask [mask]
  (var m (int/u64 0))
  (var v (int/u64 0))
  (loop [i :range [0 36]]
    (def c (in mask i))
    (*= m 2)
    (when (= c (chr "X")) (+= m 1))
    (*= v 2)
    (when (= c (chr "1")) (+= v 1)))
  [m v])

(def cmd-peg
  ~{
    :mask (* (/ "mask = " :mask) :msk)
    :msk (cmt (<- (36 (+ "1" "0" "X"))) ,parse-mask)
    :num (cmt (<- :d+) ,int/u64)
    :mem (* (/ "mem[" :mem) :num "] = " :num)
    :main (+ :mask :mem) })

(defn parse-data [inp]
  (def pg (peg/compile cmd-peg))
  (seq [line :in (string/split "\n" (string/trim inp))]
    (tuple ;(peg/match pg line))))

(def test-data-string ```
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
```)

(def test-data (parse-data test-data-string))

(def MAX_INT_U64 (int/u64 "18446744073709551615"))

(defn bnot [x] (bxor x MAX_INT_U64))

(defn apply-mask [[m v] y]
  (def y (int/u64 y))
  (bor (band y m) (band v (bnot m))))

(defn part1 [data]
  (def mem @{})
  (var mask nil)
  (loop [cmd :in data]
    (match cmd
      [:mask m] (set mask m)
      [:mem x y] (put mem x (apply-mask mask y))))
  (sum (values mem)))

(print (part1 test-data))
(def data (parse-data (slurp "input.txt")))
(print "PART1: " (part1 data))

