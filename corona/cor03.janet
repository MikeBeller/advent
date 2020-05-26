
(defn dbp [s] (do (pp s) s))

(defn read-input []
  (with [fi (file/open "inp03.txt")]
    (def nl (scan-number (string/trimr (file/read fi :line))))
    (def gridstring
      (string/join
        (seq [n :range [0 nl]]
          (buffer/slice
            (file/read fi :line)))))
    (def start
      (->>
        (file/read fi :line)
        (string/trimr)
        (string/split " ")
        (map scan-number)))
    [start gridstring]))

(defn grid-dim [g]
  [(length g) (length (g 0))])

(defn fixup-grid [g]
  (def [nr nc] (grid-dim g))
  (def nr (length g))
  (def nc (length (g 0)))
  (loop [r :range [0 nr]
         c :range [0 nc]]
    (when (= (get-in g [r c]) (chr "I"))
      (loop [ri :range [(- r 1) (+ r 2)]
             ci :range [(- c 1) (+ c 2)]]
        (when (and (>= ri 0) (< ri nr) (>= ci 0) (< ci nc))
          (put-in g [ri ci] (chr "X"))))))
  g)

(defn string-to-grid [gridstring]
  (fixup-grid
    (map buffer/slice (string/split "\n" gridstring))))

(defn grid-to-string [g]
  (string/join g "\n"))

(defn move [p d]
  (def [r c] p)
  (case d
    :n [(- r 1) c]
    :e [r (+ c 1)]
    :s [(+ r 1) c]
    :w [r (- c 1)]))

(defn legal-moves [g p]
  (def [nr nc] (grid-dim g))
  (def mv @[])
  (loop [d :in [:n :s :e :w]]
    (def [r c] (move p d))
    (when (and (>= r 0) (< r nr) (>= c 0) (< c nc))
      (def ch (get-in g [r c]))
      (when (not= ch (chr "X"))
        (array/push mv [r c]))))
  mv)

(defn search [g p]
  (def [nr nc] (grid-dim g))
  (def v (seq [_ :range [0 nr]] (array/new-filled nc)))
  (var todo @[p])
  (var steps 0)
  (put-in v p 0)
  (var answer -1)
  (while (and (= answer -1) (> (length todo) 0))
    (assert (> (length todo) 0))
    (def newdo @[])
    (++ steps)
    (loop [p :in todo]
      (when (= (get-in g p) (chr "C"))
        (set answer (dec steps))
        (break))
      (loop [p2 :in (legal-moves g p)]
        (when (nil? (get-in v p2))
          (put-in v p2 (inc steps))
          (array/push newdo p2))))
    (set todo newdo))
  answer)

(def tgs
  `..X...
...I..
.X....
..X...
X..X..
......
`)

#(print "BEFORE\n" tgs)
(def testgrid (string-to-grid tgs))
#(print "AFTER\n" (grid-to-string testgrid))

(assert (= -1 (search testgrid [5 5])))

(put-in testgrid [0 0] (chr "C"))
(assert (= 10 (search testgrid [5 5])))

(def [start gridstring] (read-input))
(def grid (string-to-grid gridstring))
(def ans (search grid start))
(print "ANSWER1 " ans)

