package main

import (
	"bytes"
	"fmt"
	"os"
)

func parse(s []byte) (g [][]int) {
	lines := bytes.Split(s, []byte("\n"))
	for _, line := range lines {
		r := make([]int, len(line))
		for c, b := range line {
			r[c] = int(b - 48)
		}
		g = append(g, r)
	}
	return
}

const INF = 999999999
const (
	RT = iota
	DN
	LT
	UP
)

type Point struct {
	r int
	c int
}

func move(p Point, dr int) Point {
	switch dr {
	case RT:
		return Point{p.r, p.c + 1}
	case DN:
		return Point{p.r + 1, p.c}
	case LT:
		return Point{p.r, p.c - 1}
	case UP:
		return Point{p.r - 1, p.c}
	}
	panic("wtf?")
}

func search(d [][]int) int {
	nr := len(d)
	nc := len(d[0])
	mn := [][]int{}
	for r := 0; r < nr; r++ {
		row := make([]int, nc)
		for c := 0; c < nc; c++ {
			row[c] = INF
		}
		mn = append(mn, row)
	}
	min_len := INF
	st := make(map[Point]int)
	st[Point{0, 0}] = 0
	for len(st) != 0 {
		new_st := make(map[Point]int)
		for p, ln := range st {
			for dr := 0; dr < 4; dr++ {
				p2 := move(p, dr)
				if p2.r >= 0 && p2.c >= 0 && p2.r < nr && p2.c < nc {
					ln2 := ln + d[p2.r][p2.c]
					if p2.r == nr-1 && p2.c == nc-1 {
						if ln2 < min_len {
							min_len = ln2
						}
						break
					}
					if ln2 < mn[p2.r][p2.c] {
						new_st[p2] = ln2
						mn[p2.r][p2.c] = ln2
					}
				}
			}
		}
		st = new_st
	}
	return min_len
}

func part1(d [][]int) int {
	return search(d)
}

func part2(d [][]int) int {
	nr1 := len(d)
	nc1 := len(d[0])
	nr2 := 5 * nr1
	nc2 := 5 * nc1

	dd := [][]int{}
	for r := 0; r < nr2; r++ {
		row := make([]int, nc2)
		dd = append(dd, row)
	}

	for i := 0; i < 5; i++ {
		for j := 0; j < 5; j++ {
			for r := 0; r < nr1; r++ {
				for c := 0; c < nc1; c++ {
					v := (d[r][c]-1+i+j)%9 + 1
					dd[r+nr1*i][c+nc1*j] = v
				}
			}
		}
	}
	ln := search(dd)
	return ln
}

var td []byte = []byte(
	`1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581`)

func main() {
	d := parse(td)
	t1 := part1(d)
	if t1 != 40 {
		panic("assertion failed")
	}

	dataStr, err := os.ReadFile("input.txt")
	if err != nil {
		panic("ReadFile")
	}
	data := parse(dataStr)

	ans1 := part1(data)
	fmt.Println("PART1:", ans1)

	t2 := part2(d)
	if t2 != 315 {
		panic("assertion t2 failed")
	}

	ans2 := part2(data)
	fmt.Println("PART2:", ans2)
}
