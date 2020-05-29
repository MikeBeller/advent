(import ./intcode :as intcode)

(defn init-amps [prog phases]
  (def amps @[])
  (loop [[i ph] :in (pairs phases)]
    (def amp (intcode/run prog))
    (assert (nil? (resume amp)))
    (assert (nil? (resume amp (phases i))))
    (array/push amps amp))
  amps)

(defn run-phases [prog phases]
  (def amps (init-amps prog phases))
  (var v 0)
  (each amp amps
    (set v (resume amp v)))
  v)

(assert (= 43210 (run-phases [3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0] [4 3 2 1 0])))

(assert (= 65210 (run-phases [3 31 3 32 1002 32 10 32 1001 31 -2 31 1007 31 0 33 1002 33 7 33 1 33 31 31 1 32 31 31 4 31 99 0 0 0] [1 0 4 3 2])))

(defn run-feedback [prog phases]
  (def amps (init-amps prog phases))
  (var v 0)
  (while (fiber/can-resume? (amps 0))
    (each amp amps
      (set v (resume amp v))
      (resume amp)))
  v)

(assert (= 139629729 (run-feedback [3 26 1001 26 -4 26 3 27 1002 27 2 27 1 27 26 27 4 27 1001 28 -1 28 1005 28 6 99 0 0 5] [9 8 7 6 5])))

(defn swap [a i j]
  (def t (a j))
  (put a j (a i))
  (put a i t))

(defn permutations [items]
  (def perms @[])
  (defn perm [a k]
    (if (= k 1)
      (array/push perms (tuple ;a))
      (do (perm a (- k 1))
        (for i 0 (- k 1)
          (if (even? k)
            (swap a i (- k 1))
            (swap a 0 (- k 1)))
          (perm a (- k 1))))))
  (perm (array/slice items) (length items))
  perms)

(assert (deep= (permutations @[1 2 3]) @[[1 2 3] [2 1 3] [3 1 2] [1 3 2] [2 3 1] [3 2 1]]))

(defn part-one [prog]
  (max
    ;(seq [phases :in (permutations @[0 1 2 3 4])]
      (tuple (run-phases prog phases) phases))))

(assert (= [43210 [4 3 2 1 0]] (part-one [3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0])))
(assert (= [65210 [1 0 4 3 2]] (part-one [3 31 3 32 1002 32 10 32 1001 31 -2 31 1007 31 0 33 1002 33 7 33 1 33 31 31 1 32 31 31 4 31 99 0 0 0])))

(def prog-str
  (with [f (file/open "input.txt")]
    (string/trimr (file/read f :all))))
(def prog (intcode/scan-prog prog-str))
(printf "PART1: %q" (part-one prog))

(defn part-two [prog]
  (max
    ;(seq [phases :in (permutations @[5 6 7 8 9])]
      (tuple (run-feedback prog phases) phases))))

(printf "PART2: %q" (part-two prog))


