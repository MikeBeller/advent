package main

import (
	"bytes"
	"fmt"
)

type Point struct {
	x int
	y int
}

type State struct {
	pos       Point
	totalDist int
	keys      KeySet
}

type KeySet int32

func isKey(b byte) bool {
	return b >= 'a' && b <= 'z'
}

func isDoor(b byte) bool {
	return b >= 'A' && b <= 'Z'
}

func (k KeySet) Add(b byte) KeySet {
	if !isKey(b) {
		panic("invalid key")
	}
	return k + (1<<k - 'a')
}

func (k KeySet) Test(b byte) bool {
	if !isKey(b) {
		panic("invalid key")
	}
	return (k & (1<<k - 'a')) != 0
}

func read_data(inp []byte) ([][]byte, map[byte]Point, KeySet, int) {
	gr := [][]byte{}
	loc := make(map[byte]Point)
	ks := KeySet(0)
	nKeys := 0
	for y, row := range bytes.Split(inp, []byte("\n")) {
		gr = append(gr, row)
		for x, c := range row {
			if c != '.' && c != '#' {
				loc[c] = Point{x, y}
				if isKey(c) {
					ks = ks.Add(c)
					nKeys++
				}
			}
		}
	}
	return gr, loc, ks, nKeys
}

func keyDistances(gr [][]byte, s State) map[byte]int {
	dst := make(map[byte]int)
	vs := make(map[Point]bool)

	var bfs func(Point, int)
	bfs = func(pos Point, depth int) {
		if vs[pos] {
			return
		}
		vs[pos] = true
		c := gr[pos.y][pos.x]
		if isKey(c) {
			dst[c] = depth
		}
		for dr := 0; dr < 4; dr++ {
			p, c := move(pos, dr)
			if c != '#' && !(isDoor(c) && !s.keys.Test(c+32)) {
				bfs(p, depth+1)
			}
		}
	}

	return dst
}

func part1(instr []byte) int {
	gr, loc, allKeys, nKeys := read_data(instr)
	q := []State{State{loc['@'], 0, KeySet(0)}}
	/*
		for depth := 0; depth < nKeys; depth++ {
			q2 := []State{}
			for _, s := range q {
				kds := keyDistances(gr, s)
				for k, dist := range kds {
					q2 = append(q2, getKey(k, dist, s))
				}
			}
			q = q2
		}

		sMin = minState(q)
		return sMin.totalDist
	*/
	dst := keyDistances(gr, q[0])
	fmt.Println(dst)
	return 9
}

func main() {
	test1 := []byte(`########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################`)
	fmt.Println("TEST1", part1(test1))

	fmt.Println("vim-go")
}
