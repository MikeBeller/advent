
(defn scan-prog [s]
  #(map scan-number (string/split "," s)))
  (map int/s64 (string/split "," s)))

(def maxint (int/s64 9007199254740992))
(def zero (int/s64 0))

(defn extract [longind]
  (assert (and (< longind maxint) (> longind (- maxint))))
  (scan-number (string/format "%V" longind)))

(defn get-long [arr longind]
  (get arr (extract longind) (int/s64 0)))

(defn put-long [arr longind val]
  (put arr (extract longind) (int/s64 val)))

(defn- get-param [prog opind mode base]
  (case mode
    (int/s64 0) (get-long prog (get-long prog opind))            # indirect
    (int/s64 1) (get-long prog opind)                            # immediate
    (int/s64 2) (get-long prog (+ base (get-long prog opind))))) # relative indirect

(defn- put-param [prog param mode base val]
  (case mode
    (int/s64 0) (put-long prog param val)
    (int/s64 2) (put-long prog (+ base param) val)))

(defn l= [a b]
  (= (int/s64 a) (int/s64 b)))

(defn run-prog [prog]
  (fiber/new
    (fn []
      (var pc (int/s64 0))
      (var base (int/s64 0))
      #(pp (map |(string/format "%V" $) prog))
      (while (not (l= (get-long prog pc) 99))
        (def o (get-long prog pc))
        (def op (% o 100))
        (def m (map |(% (/ o $) 10)
                    [100 1000 10000]))
        #(printf "OP %V M %q" op m)
        (cond
         (or (l= op 1) (l= op 2))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)
                ci (get-long prog (+ pc 3))]
            (if (l= op 1)
              (put-param prog ci (m 2) base (+ a b))
              (put-param prog ci (m 2) base (* a b)))
            (+= pc 4))
         (l= op 3)
          (do 
            (def inp (yield nil)) # get input
            #(print "INPUT: " inp)
            (def i (get-long prog (+ pc 1)))
            (put-param prog i (m 0) base (int/s64 inp))
            (+= pc 2))
         (l= op 4)
          (do 
            (def out (get-param prog (+ pc 1) (m 0) base))
            #(printf "OUTPUT: %V" out)
            (yield out)
            (+= pc 2))
         (or (l= op 5) (l= op 6))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)]
            (if (or (and (l= op 5) (not (l= a 0))) (and (l= op 6) (l= a 0)))
              (set pc b)
              (+= pc 3)))
         (or (l= op 7) (l= op 8))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)
                ci (get-long prog (+ pc 3))]
            (put-param prog ci (m 2) base
                 (if (or
                       (and (l= op 7) (< a b))
                       (and (l= op 8) (= a b)))
                   1 0))
            (+= pc 4))
         (l= op 9)
          (let [a (get-param prog (+ pc 1) (m 0) base)]
            (+= base a)
            (+= pc 2))
         (errorf "invalid intcode opcode %d at %d" op pc))
        #(printf "PC: %V MEM: %q" pc prog)
        #(printf "PC: %V" (extract pc))
        #(pp (map |(string/format "%V" $) prog))
        ))))

(defn array-to-int64 [prog]
    (def ln (length prog))
    (def ta (array/new ln))
    (loop [i :range [0 ln]]
      (put ta i (int/s64 (prog i))))
    ta)

(defn run [oprog]
  #(run-prog (array/slice oprog)))
  (run-prog (array-to-int64 oprog)))

(defn run-with-input [prog inputs]
  (def f (run prog))
  (def result @[])
  (def inputs (reverse inputs))
  (var ready-for-input nil)
  (while (fiber/can-resume? f)
    (def out
      (if ready-for-input
        (resume f (array/pop inputs))
        (resume f)))
    (set ready-for-input (nil? out))
    (unless ready-for-input
      (array/push result out)))
  result)

(defn int= [a b]
  (= (int/s64 a) (int/s64 b)))

(defn dint= [as bs]
  (and
    (= (length as) (length bs))
      (all identity (map int= as bs))))

(defn test [tf tname]
  (if tf
    (printf "OK: %s" tname)
    (printf "FAIL: %s" tname)))

(test (dint= @[(int/s64 1) (int/s64 2)] @[1 2]) "dint=1")
(test (dint= @[1 2] @[(int/s64 1) (int/s64 2)]) "dint=2")

(test (dint= @[1] (run-with-input [3 9 8 9 10 9 4 9 99 -1 8] [8])) "equal to 8")
(test (dint= @[0] (run-with-input [3 9 8 9 10 9 4 9 99 -1 8] [-1])) "not equal to 8")
(test (dint= @[0] (run-with-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [0])) "zero is zero")
(test (dint= @[1] (run-with-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [22])) "nonzero is 1")
(test (dint= @[0] (run-with-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [0])) "zero is zero immed")
(test (dint= @[1] (run-with-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [-1])) "nonzero is 1 immed")

(def- prog-big [3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99])
(test (dint= @[999] (run-with-input prog-big [7])) "big below 8")
(test (dint= @[1000] (run-with-input prog-big [8])) "big equal 8")
(test (dint= @[1001] (run-with-input prog-big [9393])) "big gt 8")

# tests for aoc 9 (adding relative mode and long numbers)
(let [p (array-to-int64 @[109 1 204 -1 1001 100 1 100 1008 100 16 101 1006 101 0 99])]
  (test (dint= (run-with-input p []) p) "copy of self"))
(let [r (run-with-input [1102 34915192 34915192 7 4 7 99 0] [])]
  (test (= 16 (length (string/format "%V" (r 0)))) "16 digit number"))
(let [r (run-with-input [104 1125899906842624 99] [])]
  (test (= "1125899906842624" (string/format "%V" (r 0))) "large number in middle"))

# need tests for relative stores &&&

