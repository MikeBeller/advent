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
	return k + (1 << (b - 'a'))
}

func (k KeySet) Test(b byte) bool {
	if !isKey(b) {
		panic("invalid key")
	}
	return (k & (1 << (b - 'a'))) != 0
}

func read_data(inp []byte) ([][]byte, map[byte]Point, int) {
	gr := [][]byte{}
	loc := make(map[byte]Point)
	nKeys := 0
	for y, row := range bytes.Split(inp, []byte("\n")) {
		gr = append(gr, row)
		if len(row) != len(gr[0]) {
			panic("Invalid input")
		}
		for x, c := range row {
			if c != '.' && c != '#' {
				loc[c] = Point{x, y}
				if isKey(c) {
					nKeys++
				}
			}
		}
	}
	return gr, loc, nKeys
}

func move(gr [][]byte, from Point, dr int) (Point, byte) {
	var to Point
	switch dr {
	case 0:
		to = Point{from.x, from.y - 1}
	case 1:
		to = Point{from.x + 1, from.y}
	case 2:
		to = Point{from.x, from.y + 1}
	case 3:
		to = Point{from.x - 1, from.y}
	default:
		panic("invalid direction")
	}
	if to.x < 0 || to.x >= len(gr[0]) || to.y < 0 || to.y >= len(gr) {
		return to, '#'
	}
	return to, gr[to.y][to.x]
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
			p, c := move(gr, pos, dr)
			if c != '#' && !(isDoor(c) && !s.keys.Test(c+32)) {
				bfs(p, depth+1)
			}
		}
	}
	bfs(s.pos, 0)

	return dst
}

func minState(q []State) State {
	minDist := 999999999999
	var minState State
	for _, s := range q {
		if s.totalDist < minDist {
			minState = s
			minDist = s.totalDist
		}
	}
	return minState
}

func getKey(k byte, p Point, dist int, s State) State {
	return State{p, s.totalDist + dist, s.keys.Add(k)}
}

func part1(instr []byte) int {
	gr, loc, nKeys := read_data(instr)
	q := []State{State{loc['@'], 0, KeySet(0)}}
	for depth := 0; depth < nKeys; depth++ {
		fmt.Println(q)
		q2 := []State{}
		for _, s := range q {
			kds := keyDistances(gr, s)
			for k, dist := range kds {
				q2 = append(q2, getKey(k, loc[k], dist, s))
			}
		}
		q = q2
	}

	sMin := minState(q)
	fmt.Println(sMin)
	return sMin.totalDist
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
