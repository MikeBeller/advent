# Without gcsetinterval, the default is to run GC
# every 64k!!

(defn make-strings [data]
  (seq
    [[x y] :in data]
    (string x "," y)))

(defn make-test-data []
  (seq [x :range [1000 2000]
        y :range [2000 3000]]
    [x y]))

(defn test1 [n]
  (gcsetinterval 1000000000)  # ensures we don't GC during test
  (def data (make-test-data))
  (loop [_ :range [0 n]]
    (make-strings data)))

#(test1 1)

(defn test2 [n]
  (gcsetinterval 1000000000)  # ensures we don't GC during test
  (def data (make-test-data))
  (def strs (make-strings data))
  (def tab @{})
  (var c 0)
  (loop [i :range [0 n]]
    (each k strs
      (++ c)
      (put tab k (+ 1 (get tab k 0)))))
  (print c))

#(test2 1)

(gcsetinterval 100000000)
(seq [i :range [0 1000000]]
  (string i))

