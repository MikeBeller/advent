;;
;; BUILDING/RUNNING:
;;
;; wat2wasm 2020-23.wat
;;
;; time wasmer run --jit --llvm 2020-23.wasm --invoke main
;; or
;; time wasmtime run --cranelift 2020-23.wasm --invoke main
;; or
;; time node.js --experimental-wasm-bigint test_wasm_node.js
;;
;; To enable printing for testing purposes, run with
;; wasm-interp --host-print --run-all-exports 2020-23.wasm
;; and uncomment the import "host" "print" lines
;;
(module
  ;;(import "host" "print" (func $print_ii (param i32 i32)))
  ;;(import "host" "print" (func $print_iiii (param i32 i32 i32 i32)))
  (memory 512)
  (func $getnxt (param $off i32) (result i32)
        (i32.load (i32.shl (local.get $off) (i32.const 2))))
  (func $setnxt (param $off i32) (param $val i32)
        (i32.store (i32.shl (local.get $off) (i32.const 2)) (local.get $val)))
  (func $move (param $ln i32)
        (local $cur i32)
        (local $n1 i32)
        (local $n2 i32)
        (local $n3 i32)
        (local $dc i32)
        (local $nx i32)

        (local.set $cur (call $getnxt (i32.const 0)))
        (local.set $n1 (call $getnxt (local.get $cur)))
        (local.set $n2 (call $getnxt (local.get $n1)))
        (local.set $n3 (call $getnxt (local.get $n2)))
        ;;(call $print_iiii (local.get $cur) (local.get $n1) (local.get $n2) (local.get $n3))
        (call $setnxt (local.get $cur) (call $getnxt (local.get $n3)))

        ;; find the next number down from cur that isn't in n1, n2 or n3,
        ;; wrapping from 0 to $ln
        (local.set $dc (i32.sub (local.get $cur) (i32.const 1)))
        (block
          (loop
            (if (i32.eq (local.get $dc) (i32.const 0))
              (then (local.set $dc (local.get $ln))))
            (br_if 1
              (i32.and
                (i32.and (i32.ne (local.get $dc) (local.get $n1))
                         (i32.ne (local.get $dc) (local.get $n2)))
                (i32.ne (local.get $dc) (local.get $n3))))
            (local.set $dc (i32.sub (local.get $dc) (i32.const 1)))
            (br 0)))

        (local.set $nx (call $getnxt (local.get $dc)))
        (call $setnxt (local.get $dc) (local.get $n1))
        (call $setnxt (local.get $n3) (local.get $nx))

        (call $setnxt (i32.const 0) (call $getnxt (local.get $cur)))
        )

  ;; extract the 9-nth hex digit from $init
  (func $initdigit (param $init i64) (param $n i32) (result i32)
        ;; calculate digit number to extract
        (local $dn i32)
        (local.set $dn (i32.sub (i32.const 8) (local.get $n)))
        (i32.wrap_i64
          (i64.and
            (i64.const 0x0f)
            (i64.shr_u
              (local.get $init)
              (i64.extend_i32_u
                (i32.shl (local.get $dn) (i32.const 2)))))))

  (func $part2 (param $init i64) (param $nmoves i32) (result i64)
        (local $p i32)
        (local $i i32)
        (local $nv i32)
        (local $mx i32)
        (local $l1 i32)
        (local $l2 i32)

        ;; initialize the NXT array based on the hex digits of the init param
        (local.set $p (call $initdigit (local.get $init) (i32.const 0)))
        (call $setnxt (i32.const 0) (local.get $p))
        (local.set $i (i32.const -1))
        ;;(local.set $mx (i32.const 9))
        (local.set $mx (i32.const 1000001))
        (block
          (loop
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br_if 0 (i32.eq (local.get $i) (i32.const 9)))
            (br_if 1 (i32.eq (local.get $i) (local.get $mx)))
            (local.set $nv 
                       (if (result i32)
                         (i32.lt_u (local.get $i) (i32.const 9))
                         (then 
                            (call $initdigit (local.get $init) (local.get $i)))
                         (else (local.get $i))))
            (call $setnxt (local.get $p) (local.get $nv))
            (local.set $p (local.get $nv))
            (br 0)))
        (call $setnxt (local.get $p) (call $getnxt (i32.const 0)))

        ;; loop MX times
        (local.set $i (i32.const 0))
        (local.set $mx (local.get $nmoves))
        (block
          (loop
            (br_if 1 (i32.eq (local.get $i) (local.get $mx)))
            (call $move (i32.const 1000000))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br 0)))

        ;; find the two items to the right of "1" in the circle, multiply and return
        (local.set $l1 (call $getnxt (i32.const 1)))
        (local.set $l2 (call $getnxt (local.get $l1)))
        ;;(call $print_ii (local.get $l1) (local.get $l2))
        (i64.mul
          (i64.extend_i32_s (local.get $l1))
          (i64.extend_i32_s (local.get $l2))))

  (func $main (export "main") (result i64)
        ;;(call $part2 (i64.const 0x0389125467) (i32.const 10000000))
        ;;(drop)
        (call $part2 (i64.const 0x0219748365) (i32.const 10000000)))
  )

