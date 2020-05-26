
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

(defn fixup-grid [g]
  (def nr (length g))
  (def nc (length (g 0)))
  (loop [r :range [0 nr]
         c :range [0 nc]]
    (when (= (get-in [r c] g)) (chr "I"))
    (loop [ro :range [-1 2]
           co :range [-1 2]]
      (set ((g (+ r ro)) (+ c co)) (chr "X"))))
  g)

(defn string-to-grid [gridstring]
  (fixup-grid
    (map buffer/slice (string/split "\n" gridstring))))

(defn grid-to-string [g]
  (string/join g "\n"))

(def tgs
  `..X...
...I..
.X....
..X...
X..X..
......
`)

(print (grid-to-string (string-to-grid tgs)))

(def [start gridstring] (read-input))
(def grid (string-to-grid gridstring))
(pp start)


