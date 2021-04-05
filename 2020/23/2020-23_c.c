#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <inttypes.h>

#define T int32_t

/* compile with:
 *   gcc -O3 -o 2020-23_c 2020-23_c.c
 *   or
 *   emcc -O3 -o 2020-23_c.js 2020-23_c.c
 *   then run: node 2020-23_c.js
 *
 *   Timing for emcc (wasm) is only a bit worse than optimized C!
 *   (.26s for WASM vs .22s for C -O3)
 */

void move(T ln, T nxt[]) {
    T cur = nxt[0];
    T n1 = nxt[cur];
    T n2 = nxt[n1];
    T n3 = nxt[n2];
    nxt[cur] = nxt[n3];

    T dc = cur - 1;
    if (dc == 0)
        dc = ln;

    while (dc == n1 || dc == n2 || dc == n3) {
        dc--;
        if (dc == 0)
            dc = ln;
    }

    T nx = nxt[dc];
    nxt[dc] = n1;
    nxt[n3] = nx;

    nxt[0] = nxt[cur];
    return;
}


int64_t part1(T cs[], size_t nmoves) {
    T ln = 9;
    T nxt[10];
    T p = cs[0];
    nxt[0] = cs[0];
    for (size_t i = 1; i < ln; i++) {
        nxt[p] = cs[i];
        p = nxt[p];
    }
    nxt[p] = nxt[0];

    for (size_t i = 0; i < nmoves; i++) {
        move(ln, nxt);
    }

    int64_t r = 0;
    p = 1;
    while (nxt[p] != 1) {
        r *= 10;
        r += nxt[p];
        p = nxt[p];
    }
    return r;
}

#define MX 1000000
#define CS 9

int64_t part2(T cs[], size_t nmoves) {
    T nxt[1000001];
    T p = cs[0];
    nxt[0] = cs[0];
    for (size_t i = 1; i <= MX; i++) {
        if (i < CS)
            nxt[p] = cs[i];
        else if (i == CS)
            continue;
        else
            nxt[p] = i;
        p = nxt[p];
    }
    nxt[p] = nxt[0];

    for (size_t i = 0; i < nmoves; i++) {
        move(MX, nxt);
    }

    T l1 = nxt[1];
    T l2 = nxt[l1];

    return (int64_t) l1 * (int64_t) l2;
}

int main() {
    /*
    T p1data[9] = {3, 8, 9, 1, 2, 5, 4, 6, 7};
    int64_t ans = part1(p1data, 10);
    printf("%ld\n", ans);
    ans = part2(p1data, 10000000);
    printf("%ld\n", ans);
    */

    T p2data[9] = {2, 1, 9, 7, 4, 8, 3, 6, 5};
    int64_t ans2 = part2(p2data, 10000000);
    printf("PART2: %" PRId64 "\n", ans2);
    return 0;
}
