# picolisp

(de bench (n)
    (let (i 0 s 0)
        (do n
            (setq s (+ s i))
            (inc i)
         )
    )
)

(print (bench 100000000))
(bye)