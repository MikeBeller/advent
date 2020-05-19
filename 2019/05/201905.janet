
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
              (def i (prog (+ pc 1)))
              (put prog i inp)
              (+= pc 2))
          (= op 4)
            (do 
              (def out (get-param prog (prog (+ pc 1)) (m 0)))
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
              (if (= op 1)
                (put prog ci
                     (if (and (= op 7) (< a b)) 1 0))
                (+= pc 4)))
          (errorf "invalid intcode opcode %d at %d" op pc))))))

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

(pp (run-input [3 9 8 9 10 9 4 9 99] [8]))

