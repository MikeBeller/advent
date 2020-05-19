
(defn scan-prog [s]
  (map |(scan-number $) (string/split "," s)))

(defn get-param [prog op mode]
  (if (= mode 1) op (get prog op 0)))

(defn run-prog [prog]
  (fiber/new
    (fn []
      (var pc 0)
      (while (not= (prog pc) 99)
        (def o (prog pc))
        (def op (% o 100))
        (def m (map |(% (math/floor (/ o $)) 10)
                    [100 1000 10000]))
        #(printf "OP %d M %q" op m)
        (cond
         (or (= op 1) (= op 2))
          (let [a (get-param prog (prog (+ pc 1)) (m 0))
                b (get-param prog (prog (+ pc 2)) (m 1))
                ci (prog (+ pc 3))]
            (if (= op 1)
              (put prog ci (+ a b))
              (put prog ci (* a b)))
            (+= pc 4))
         (= op 3)
          (do 
            (def inp (yield nil)) # get input
            #(print "INPUT: " inp)
            (def i (prog (+ pc 1)))
            (put prog i inp)
            (+= pc 2))
         (= op 4)
          (do 
            (def out (get-param prog (prog (+ pc 1)) (m 0)))
            #(printf "OUTPUT: %d" out)
            (yield out)
            (+= pc 2))
         (or (= op 5) (= op 6))
          (let [a (get-param prog (prog (+ pc 1)) (m 0))
                b (get-param prog (prog (+ pc 2)) (m 1))]
            (if (or (and (= op 5) (not= a 0)) (and (= op 6) (= a 0)))
              (set pc b)
              (+= pc 3)))
         (or (= op 7) (= op 8))
          (let [a (get-param prog (prog (+ pc 1)) (m 0))
                b (get-param prog (prog (+ pc 2)) (m 1))
                ci (prog (+ pc 3))]
            (put prog ci
                 (if (or
                       (and (= op 7) (< a b))
                       (and (= op 8) (= a b)))
                   1 0))
            (+= pc 4))
         (errorf "invalid intcode opcode %d at %d" op pc))
        #(printf "PC: %d MEM: %q" pc prog)
        ))))

(defn run-input [oprog inputs]
  (def prog (array/slice oprog))
  (def f (run-prog prog))
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

(assert (deep= @[1] (run-input [3 9 8 9 10 9 4 9 99 -1 8] [8])) "equal to 8")
(assert (deep= @[0] (run-input [3 9 8 9 10 9 4 9 99 -1 8] [-1])) "not equal to 8")
(assert (deep= @[0] (run-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [0])) "zero is zero")
(assert (deep= @[1] (run-input [3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9] [22])) "nonzero is 1")
(assert (deep= @[0] (run-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [0])) "zero is zero immed")
(assert (deep= @[1] (run-input [3 3 1105 -1 9 1101 0 0 12 4 12 99 1] [-1])) "nonzero is 1 immed")

(def prog-big [3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31 1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104 999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99])
(assert (deep= @[999] (run-input prog-big [7])) "big below 8")
(assert (deep= @[1000] (run-input prog-big [8])) "big equal 8")
(assert (deep= @[1001] (run-input prog-big [9393])) "big gt 8")

(def prog-str
  (with [f (file/open "input.txt")]
    (string/trimr (file/read f :all))))
(def prog (scan-prog prog-str))
(printf "PARTONE: %q" (run-input prog @[1]))
(printf "PARTTWO: %q" (run-input prog @[5]))


