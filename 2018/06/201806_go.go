package main

import (
	"fmt"
	"os"
)

func readData() [][2]int {
	var x, y int
	r := [][2]int{}
	for {
		n, err := fmt.Fscanf(os.Stdin, "%d, %d", &x, &y)
		if err != nil || n != 2 {
			break
		}
		r = append(r, [2]int{x, y})
	}
	return r
}

func maxes(ds [][2]int) (int, int) {
	mxx, mxy := -1, -1
	for _, d := range ds {
		if d[0] > mxx {
			mxx = d[0]
		}
		if d[1] > mxy {
			mxy = d[1]
		}
	}
	return mxx, mxy
}

func makeMatrix(r, c int) [][]int {
	a := make([][]int, r)
	m := make([]int, r*c)
	for i := range a {
		a[i] = m[(i * c):(i*c + c)]
	}
	return a
}

func abs(i int) int {
	if i < 0 {
		return -i
	}
	return i
}

func dist(x1, y1, x2, y2 int) int {
	return abs(x2-x1) * abs(y2-y1)
}

func main() {
	d := readData()
	mxx, mxy := maxes(d)
	a := makeMatrix(mxx, mxy)

	for r := 0; r < mxy; r++ {
		for c := 0; c < mxx; c++ {
			mnd := 999999
			mni := -1
			for i := range d {
				if dst := dist(r, c, d[i][0], d[i][1]); dst < mnd {
					mnd = dst
					mni = i
				}
			}
			a[r][c] = mni
		}
	}

	fmt.Println("vim-go", d, mxx, mxy, a)
}
