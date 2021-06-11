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

# override this so it works for int/u64 types
(defn bnot [x] (- (- x) 1))

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

(defn get-bit [n i] (band 1 (brshift n i)))
(defn set-bit [n i b] (bor n (blshift (int/u64 b) i)))

(defn masked-val [[m0 v0] x0 c0]
  (var r 0)
  (var m m0)
  (var v v0)
  (var x x0)
  (var c c0)
  (loop [i :range [0 36]]
    (var rb 0)
    (if (zero? (band m 1))
      (if (zero? (band v 1)) (set rb (band x 1)) (set rb 1))
      (do
        (set rb (band c 1))
        (set c (brshift c 1))))
    (set m (brshift m 1))
    (set v (brshift v 1))
    (set x (brshift x 1))
    (if (not (zero? rb))
      (+= r (blshift (int/u64 1) i))))
  r)

(defn masked-vals [mask x]
  (def [m _v] mask)
  (def nm (count |(not (zero? $)) (seq [i :range [0 36]] (get-bit m i))))
  (def nc (blshift 1 nm))
  (seq [i :range [0 nc]]
    (masked-val mask x i)))

(defn part2 [data]
  (def mem @{})
  (var mask nil)
  (loop [cmd :in data]
    (match cmd
      [:mask m] (set mask m)
      [:mem x y] (loop [a :in (masked-vals mask x)]
                   (put mem a y))))
  (sum (values mem)))


(assert (compare= 165 (part1 test-data)))
(def data (parse-data (slurp "input.txt")))
(print "PART1: " (part1 data))

(def tm (parse-mask "000000000000000000000000000000X1001X"))
(assert (deep= (masked-vals tm 42) (seq [i :in [26 27 58 59]] (int/u64 i))))
(print "PART2: " (part2 data))
