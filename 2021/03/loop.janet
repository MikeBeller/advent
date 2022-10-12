(defn bench [n]
    (var sum 0)
    (for i 0 n (+= sum i))
    sum)

(print (bench 100000000))