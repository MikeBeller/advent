
(module
  (memory 1)
  (func $getnxt (param $off i32) (result i32)
        (i32.load (i32.shl (i32.const 2) (local.get $off))))
  (func $setnxt (param $off i32) (param $val i32)
        (i32.store (i32.shl (i32.const 2) (local.get $off)) (local.get $val)))
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
            (br 0)))

        (local.set $nx (call $getnxt (local.get $dc)))
        (call $setnxt (local.get $dc) (local.get $n1))
        (call $setnxt (local.get $n3) (local.get $nx))

        (call $setnxt (i32.const 0) (call $getnxt (local.get $cur)))
        )

  ;; extract the 9-nth hex digit from $init
  (func $initdigit (param $init i64) (param $n i32) (result i32)
        (i32.wrap_i64
          (i64.and
            (i64.const 0x0f)
            (i64.shr_u
              (local.get $init)
              (i64.extend_i32_u (local.get $n))))))

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
        (local.set $i (i32.const 1))
        (local.set $mx (i32.const 9))
        (block
          (loop
            (br_if 1 (i32.eq (local.get $i) (local.get $mx)))
            (local.set $nv (call $initdigit (local.get $init) (local.get $i)))
            (call $setnxt (local.get $p) (local.get $nv))
            (local.set $p (local.get $nv))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br 0)))
        (call $setnxt (local.get $p) (call $getnxt (i32.const 0)))

        ;; loop MX times
        (local.set $i (i32.const 0))
        (local.set $mx (local.get $nmoves))
        (block
          (loop
            (br_if 1 (i32.gt_u (local.get $i) (local.get $mx)))
            (call $move (i32.const 9))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br 0)))

        ;; find the two items to the right of "1" in the circle, multiply and return
        (local.set $l1 (call $getnxt (i32.const 1)))
        (local.set $l2 (call $getnxt (local.get $l1)))
        (i64.mul
          (i64.extend_i32_s (local.get $l1))
          (i64.extend_i32_s (local.get $l2))))

  (func $main (export "_start") (result i64)
        (call $part2 (i64.const 0x389125467) (i32.const 10)))
  )

