// Assemblyscript version of 2020-23
//
// To build:
// asc -O3 --runtime none --initialMemory 1024 2020-23_assemblyscript.ts -o 2020-23_assemblyscript.wasm
//
// To run:
// wasmer run 2020-23_assemblyscript.wasm --invoke main
// (or wasmtime instead of wasmer)
// 
// For speed:
// wasmer run --jit --llvm 2020-23_assemblyscript.wasm --invoke main

// For debut printing you can uncomment the below line (and corresponding
// print_iiii lines in the source), and run the wasm file with
//   wasm-interp --host-print 2020-23_assemblyscript.wasm --run-all-exports
//@external("host", "print")
//export declare function print_iiii(a: i32, b: i32, c: i32, d: i32): void;

function getnxt(off: i32) : i32 {
    return load<i32>(off << 2);
}

function setnxt(off: i32, val: i32): void {
    store<i32>(off << 2, val);
}

function move(ln: i32):void {
    let cur = getnxt(0);
    let n1 = getnxt(cur);
    let n2 = getnxt(n1);
    let n3 = getnxt(n2);
    setnxt(cur, getnxt(n3));
    //print_iiii(cur, n1, n2, n3);

    let dc = cur - 1;
    if (dc == 0) dc = ln;
    while (dc == n1 || dc == n2 || dc == n3) {
        dc -= 1;
        if (dc == 0) dc = ln;
    }

    let nx = getnxt(dc);
    setnxt(dc, n1);
    setnxt(n3, nx);
    setnxt(0, getnxt(cur));
}

function initdigit(init: i64, n: i32) : i32 {
    let dn = 8 - n;
    return i32(0x0f & (init >> (i64(dn) << 2)));
}

function part2(init: i64, nmoves: i32) : i64 {
    //const mx = 9;  // part1
    const mx = 1000000; // part2
    let p = initdigit(init, 0);
    setnxt(0, p);
    for (let i = 1; i <= mx; i++) {
        if (i == 9) continue;
        const nv = (i < 9) ? initdigit(init, i) : i;
        setnxt(p, nv);
        p = nv;
    }
    setnxt(p, getnxt(0));

    for (let i = 0; i < nmoves; i++) {
        move(mx);
    }

    const l1 = getnxt(1);
    const l2 = getnxt(l1);
    return i64(l1) * i64(l2);
}

export function main(): i64 {
    //return part2(0x0389125467, 10000000);
    return part2(0x0219748365, 10000000);
}
