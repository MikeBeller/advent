
(module
  (memory 1)
  (func $nxt (param $off i32) (result i32)
        (i32.load (i32.shl (i32.const 2) (local.get $off))))
  (func $setnxt (param $off i32) (param $val i32)
        (i32.store (i32.shl (i32.const 2) (local.get $off)) (local.get $val)))
  (func $move (param $ln i32)
        (local $cur i32)
        (local $n1 i32)
        (local $n2 i32)
        (local $n3 i32)
        (local.set $cur (call $nxt (i32.const 0)))
        (local.set $n1 (call $nxt (local.get $cur)))
        (local.set $n2 (call $nxt (local.get $n1)))
        (local.set $n3 (call $nxt (local.get $n2)))
        (call $setnxt (i32.const 0)
              (i32.add
                (local.get $n1)
                (i32.add
                  (local.get $n2) (local.get $n3)))))
  (func $part1 (export "_start") (result i32)
        (call $setnxt (i32.const 0) (i32.const 1))
        (call $setnxt (i32.const 1) (i32.const 2))
        (call $setnxt (i32.const 2) (i32.const 3))
        (call $setnxt (i32.const 3) (i32.const 4))
        (call $setnxt (i32.const 4) (i32.const 5))
        (call $move (i32.const 5))
        (call $nxt (i32.const 0))
        )
  )


