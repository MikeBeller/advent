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
    if (newX < 0 || newY >= gr[0].length || newY < 0 || newY >= gr.length) {
        return [to, '#'];
    }
    return [to, gr[newY][newX]];
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

