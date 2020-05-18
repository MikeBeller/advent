
(defn parse-data [str]
  (map
    scan-number
    (string/split "," str)))

(def data
  (with [f (file/open "input.txt")]
    (string/trimr (file/read f :all))))

(defn run-intcode [prog]
  (var pc 0)
  (while true
    (def i (get prog pc))
    (if (= i 99)
      (break)
      (let [ai (get prog (+ 1 pc))
            bi (get prog (+ 2 pc))
            ci (get prog (+ 3 pc))]
        (put prog ci
             (case i
               1 (+ (prog ai) (prog bi))
               2 (* (prog ai) (prog bi))))))
    (+= pc 4))
  prog)

(defn run-prog [oprog noun verb]
  (def prog (array/slice oprog))
  (put prog 1 noun)
  (put prog 2 verb)
  (run-intcode prog)
  (prog 0))

(defn part-one []
  (def prog (parse-data data))
  (run-prog prog 12 2))

(print (part-one))

(defn part-two []
  (def prog (parse-data data))
  (var ans nil)
  (loop [n :range [0 100]
         v :range [0 100]]
    (if (= 19690720 (run-prog prog n v))
      (do
        (set ans (+ v (* n 100)))
        (break))))
  ans)

(print (part-two))


