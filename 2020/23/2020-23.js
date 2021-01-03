function move(nxt) {
    let ln = nxt.length - 1;
    let cur = nxt[0];
    let n1 = nxt[cur];
    let n2 = nxt[n1];
    let n3 = nxt[n2];
    nxt[cur] = nxt[n3];

    let dc = cur - 1;
    if (dc == 0) dc = ln;
    while (dc == n1 || dc == n2 || dc == n3) {
        dc -= 1;
        if (dc == 0) dc = ln;
    }

    let nx = nxt[dc];
    nxt[dc] = n1;
    nxt[n3] = nx;
    nxt[0] = nxt[cur];
}

function part2(init, nmoves) {
    //const mx = 9;  // part1
    const mx = 1000000; // part2
    let nxt = new Int32Array(mx+1);
    let p = init[0];
    nxt[0] = p;
    for (let i = 1; i <= mx; i++) {
        if (i == 9) continue;
        const nv = (i < 9) ? init[i] : i;
        nxt[p] = nv;
        p = nv;
    }
    nxt[p] = nxt[0];

    for (let i = 0; i < nmoves; i++) {
        move(nxt);
    }

    const l1 = nxt[1];
    const l2 = nxt[l1];
    return l1 * l2;
}

function main() {
    //console.log( part2([3, 8, 9, 1, 2, 5, 4, 6, 7], 10000000));
    console.log( part2([2, 1, 9, 7, 4, 8, 3, 6, 5], 10000000));
}

main()

