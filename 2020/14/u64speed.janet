# seems to demonstrate that u64's are 16 times slower than numbers
(defn norm []
  (var x 0)
  (loop [i :range [0 1000000]]
    (loop [j :range [0 32]]
      (set x (bor x (blshift 1 j)))))
  x)

(defn u64 []
  (var x (int/u64 0))
  (loop [i :range [0 1000000]]
    (loop [j :range [0 32]]
      (set x (bor x (blshift (int/u64 1) j)))))
  x)


(import spork/test)
(test/timeit (norm))
(test/timeit (u64))

