
# "language"
# Only data types are nil, number, cons, symbol
# List is the usual LISP definition (3 4 5) => (cons 3 (cons 4 (cons 5 nil)))
# String is just a list of chars (ascii integer numbers)
# Symbol is just a string interned in "the symbol table" -- not a data type
# have def, fn (lambda), cons/car/cdr, and/or/not, +-*/,% </>/<=/>=/=
# atom? (defined as not a cons) nil? number?
# also print
# we allow (let [a b] body) because it's equal to:
#    ((fn [a] body) b)
# def at root assigns symbol to value, else it's equal to letrec
(defn cons [a b] (tuple a b))
(defn car [c] (assert (tuple? c)) (in c 0))
(defn cdr [c] (assert (tuple? c)) (in c 1))
(defn getc []
  (let [b (file/read stdin 1)]
    (if (nil? b) nil (in b 0))))

# Program to sum a file of numbers in simplistic lisp
(def dnum
  (fn []
    ((fn looop [n]
      (let [c (getc)]
        (cond
          (or (nil? c) (< c 48) (> c 57)) (cons n c)
          (looop (+ (* n 10) (- c 48))))))
     0)))


(def sumfile
  (fn []
    ((fn looop [sm]
      (let [c (dnum)]
        (cond
          (nil? (cdr c)) (+ sm (car c))
          (looop (+ sm (car c))))))
     0)))

(print (sumfile))

