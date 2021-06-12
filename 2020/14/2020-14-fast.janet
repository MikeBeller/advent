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
(defn set-bit [n i b]
  (def m (blshift (int/u64 1) i))
  (if (zero? b)
    (band n (bnot m))
    (bor n m)))

(defn bit-locs [m]
  (seq [i :range [0 36]
        :when (not (zero? (get-bit m i)))]
    i))

(defn masked-val [[m v bs] x c]
  (var r (bor x v))
  (loop [[i n] :pairs bs]
    (set r (set-bit r n (get-bit c i))))
  r)

(defn masked-vals [mask x]
  (def [_m _v bs] mask)
  (def nc (blshift 1 (length bs)))
  (seq [i :range [0 nc]]
    (masked-val mask x i)))

(defn part2 [data]
  (def mem @{})
  (var mask nil)
  (loop [cmd :in data]
    (match cmd
      [:mask [m v]] (set mask [m v (bit-locs m)])
      [:mem x y] (loop [a :in (masked-vals mask x)]
                   (put mem a y))))
  (sum (values mem)))


(assert (compare= 165 (part1 test-data)))
(def data (parse-data (slurp "input.txt")))
(print "PART1: " (part1 data))

(def [m v] (parse-mask "000000000000000000000000000000X1001X"))
(def tm [m v (bit-locs m)])
(assert (deep= (masked-vals tm 42) (seq [i :in [26 27 58 59]] (int/u64 i))))

(import spork/test)
(def ans (test/timeit (part2 data)))
(print "PART2: " ans)
