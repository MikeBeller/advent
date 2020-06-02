
(defn scan-prog [s]
  (map scan-number (string/split "," s)))

(defn- get-param [prog opind mode base]
  (case mode
    0 (get prog (get prog opind 0) 0)            # indirect
    1 (get prog opind 0)                         # immediate
    2 (get prog (+ base (get prog opind 0)) 0))) # relative indirect

(defn- put-param [prog param mode base val]
  (case mode
    0 (put prog param val)
    2 (put prog (+ base param) val)))

(defn run-prog [prog]
  (fiber/new
    (fn []
      (var pc 0)
      (var base 0)
      (while (not (= (get prog pc 0) 99))
        (def o (get prog pc 0))
        (def op (% o 100))
        (def m (map |(% (math/floor (/ o $)) 10)
                    [100 1000 10000]))
        #(printf "OP %V M %q" op m)
        (cond
         (or (= op 1) (= op 2))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)
                ci (get prog (+ pc 3) 0)]
            (if (= op 1)
              (put-param prog ci (m 2) base (+ a b))
              (put-param prog ci (m 2) base (* a b)))
            (+= pc 4))
         (= op 3)
          (do 
            (def inp (yield nil)) # get input
            #(print "INPUT: " inp)
            (def i (get prog (+ pc 1) 0))
            (put-param prog i (m 0) base inp)
            (+= pc 2))
         (= op 4)
          (do 
            (def out (get-param prog (+ pc 1) (m 0) base))
            #(printf "OUTPUT: %V" out)
            (yield out)
            (+= pc 2))
         (or (= op 5) (= op 6))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)]
            (if (or (and (= op 5) (not (= a 0))) (and (= op 6) (= a 0)))
              (set pc b)
              (+= pc 3)))
         (or (= op 7) (= op 8))
          (let [a (get-param prog (+ pc 1) (m 0) base)
                b (get-param prog (+ pc 2) (m 1) base)
                ci (get prog (+ pc 3) 0)]
            (put-param prog ci (m 2) base
                 (if (or
                       (and (= op 7) (< a b))
                       (and (= op 8) (= a b)))
                   1 0))
            (+= pc 4))
         (= op 9)
          (let [a (get-param prog (+ pc 1) (m 0) base)]
            (+= base a)
            (+= pc 2))
         (errorf "invalid intcode opcode %d at %d" op pc))
        #(printf "PC: %V MEM: %q" pc prog)
        ))))

(defn run [oprog]
  (run-prog (array/slice oprog)))

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

(defn test [tf tname]
  (if tf
    (printf "OK: %s" tname)
    (printf "FAIL: %s" tname)))

(test (deep= @[1] (run-with-input [3 9 8 9 10 9 4 9 99 -1 8] [8])) "equal to 8")
(test (deep= @[0] (run-with-input [3 9 8 9 10 9 4 9 99 -1 8] [-1])) "not equal to 8")
(test (deep= @[0] (run-with-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [0])) "zero is zero")
(test (deep= @[1] (run-with-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [22])) "nonzero is 1")
(test (deep= @[0] (run-with-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [0])) "zero is zero immed")
(test (deep= @[1] (run-with-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [-1])) "nonzero is 1 immed")

(def- prog-big [3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99])
(test (deep= @[999] (run-with-input prog-big [7])) "big below 8")
(test (deep= @[1000] (run-with-input prog-big [8])) "big equal 8")
(test (deep= @[1001] (run-with-input prog-big [9393])) "big gt 8")

# tests for aoc 9 (adding relative mode and long numbers)
(let [p @[109 1 204 -1 1001 100 1 100 1008 100 16 101 1006 101 0 99]]
  (test (deep= (run-with-input p []) p) "copy of self"))
(let [r (run-with-input [1102 34915192 34915192 7 4 7 99 0] [])]
  (test (= 16 (length (string/format "%.0f" (r 0)))) "16 digit number"))
(let [r (run-with-input [104 1125899906842624 99] [])]
  (test (= "1125899906842624" (string/format "%.0f" (r 0))) "large number in middle"))

# need tests for relative stores &&&

