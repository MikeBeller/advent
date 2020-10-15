'use strict';
var assert = require('assert');

const isKey = c => c >= 'a' && c <= 'z';
const isDoor = c => c >= 'A' && c <= 'Z';
function keyForDoor(c) {
    assert(isDoor(c), "Invalid door in keyForDoor");
    return c.toLowerCase();
}

function readData(inStr) {
    let gr = [];
    let loc = {};
    let nKeys = 0;
    let lines = inStr.split("\n");
    for (const [y,row] of lines.entries()) {
        if (row == "") break;
        gr.push(row);
        assert(row.length == gr[0].length);
        for (const [x,c] of row.split("").entries()) {
            if (c != '.' && c != '#') {
                loc[c] = [x, y];
                if (isKey(c)) nKeys++;
            }
        }
    }
    return [gr, loc, nKeys];
}

const gridSize = (gr) => [gr.length, gr[0].length];

function move(gr, from, dr) {
    let to = [0, 0];
    const [x,y] = from;
    switch (dr) {
        case 0:
            to = [x, y-1];
            break;
        case 1:
            to = [x + 1, y];
            break;
        case 2:
            to = [x, y + 1];
            break;
        case 3:
            to = [x - 1, y];
            break;
        default:
            assert(false, "invalid direction");
    }
    const [newX,newY] = to;
    let [nr, nc] = gridSize(gr);
    if (newX < 0 || newX >= nc || newY < 0 || newY >= nr) {
        return [to, '#'];
    }
    return [to, gr[newY][newX]];
}

function keyDistances(gr, from_pos, keys) {
    let dst = {};
    let [nr, nc] = gridSize(gr);
    for (let y = 0; y < nr; y++) {
        vs[y] = new Array(gr.length).fill(false);
    }

    let q = [(from_pos, 0)];
    while (q.length != 0) {
        let [[x,y],dist] = q.shift();
        if (!vs[y][x]) {
            vs[y][x] = true;
            let c = gr[y][x];
            if (isKey(c) && !keys.has(c)) {
                dst[c] = dist;
            }
            for (let dr = 0; dr < 4; dr++) {
                let [[xNew,yNew], cc] = move(gr, [x, y], dr);
                if (cc == '#' || (isDoor(cc) && !keys.has(keyForDoor(cc)))) {
                    continue
                }
                q.push([[xNew, yNew], dist+1]);
            }
        }
    }
    return dst;
}

function partOne(inStr) {
    const [gr, loc, nKeys] = readData(inStr);

}

function runTests() {
    assert(isKey('b') && !isKey('Z'));
    assert(!isDoor('b') && isDoor('Z'));
    assert(keyForDoor('A') == 'a');

    const test1 = "###\n#.a\n.Z.";
    const [gr,loc,nKeys] = readData(test1);
    assert.deepEqual(gr, ["###", "#.a", ".Z."]);
    assert.deepEqual(loc, { a: [ 2, 1 ], Z: [ 1, 2 ] });
    assert(nKeys == 1);

    assert.deepEqual(move(gr, [1,1], 1), [[2, 1], 'a']);
    assert.deepEqual(move(gr, [2,2], 2), [[2, 3], '#']);
}

runTests();

