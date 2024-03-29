package main

import "fmt"

func readData() (r []int) {
	var x int
	for {
		n, err := fmt.Scan(&x)
		if n != 1 || err != nil {
			break
		}
		r = append(r, x)
	}
	return
}

func partOne(data []int) int {
	s := 0
	for _, x := range data {
		s += (x / 3) - 2
	}
	return s
}

func fuelR(m int) int {
	f := m/3 - 2
	if f <= 0 {
		return 0
	}
	return f + fuelR(f)
}

func partTwo(data []int) int {
	s := 0
	for _, m := range data {
		s += fuelR(m)
	}
	return s
}

func main() {
	data := readData()
	ans1 := partOne(data)
	fmt.Println("Part 1:", ans1)
	ans2 := partTwo(data)
	fmt.Println("Part 1:", ans2)
}
