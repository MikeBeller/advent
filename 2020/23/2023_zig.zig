const std = @import("std");
const expect = std.testing.expect;

fn move(ln: u32, nxt: []u32) void {
    const cur: u32 = nxt[0];
    const n1: u32 = nxt[cur];
    const n2: u32 = nxt[n1];
    const n3: u32 = nxt[n2];
    nxt[cur] = nxt[n3];
    //std.debug.print("{} {} {} {}\n", .{ cur, n1, n2, n3 });

    var dc = cur - 1;
    if (dc == 0)
        dc = ln;

    while (dc == n1 or dc == n2 or dc == n3) {
        dc = if (dc == 1) ln else dc - 1;
    }

    const nx: u32 = nxt[dc];
    nxt[dc] = n1;
    nxt[n3] = nx;

    nxt[0] = nxt[cur];
    return;
}

const CS = 9;

fn part1(cs: [CS]u32, nmoves: u32) u64 {
    const ln: u32 = CS;
    var nxta: [CS + 1]u32 = undefined;
    var nxt = nxta[0..];
    var p: u32 = cs[0];
    nxt[0] = cs[0];
    var i: u32 = 1;
    while (i < ln) : (i += 1) {
        nxt[p] = cs[i];
        p = nxt[p];
    }
    nxt[p] = nxt[0];

    i = 0;
    while (i < nmoves) : (i += 1) {
        move(ln, nxt);
    }

    var r: u64 = 0;
    p = 1;
    while (nxt[p] != 1) : (p = nxt[p]) {
        r *= 10;
        r += nxt[p];
    }
    return r;
}

const MX = 1000000;

fn part2(cs: [CS]u32, nmoves: u32) u64 {
    var nxta: [MX + 1]u32 = undefined;
    var nxt = nxta[0..];
    var p: u32 = cs[0];
    nxt[0] = cs[0];
    var i: u32 = 1;
    while (i <= MX) : (i += 1) {
        if (i < CS) {
            nxt[p] = cs[i];
        } else if (i == CS) {
            continue;
        } else {
            nxt[p] = i;
        }
        p = nxt[p];
    }
    nxt[p] = nxt[0];

    i = 0;
    while (i < nmoves) : (i += 1) {
        move(MX, nxt);
    }

    const l1: u64 = nxt[1];
    const l2: u64 = nxt[l1];
    //std.debug.print("L1 {} L2 {}\n", .{ l1, l2 });

    return l1 * l2;
}

test "part1" {
    const cs = [_]u32{ 3, 8, 9, 1, 2, 5, 4, 6, 7 };
    const r = part1(cs, 10);
    expect(r == 92658374);
}

test "part2" {
    const cs = [_]u32{ 3, 8, 9, 1, 2, 5, 4, 6, 7 };
    const r = part2(cs, 10000000);
    expect(r == 149245887792);
}

pub fn main() void {
    const cs = [_]u32{ 2, 1, 9, 7, 4, 8, 3, 6, 5 };
    const r = part2(cs, 10000000);
    std.debug.print("PART2: {}\n", .{r});
}
