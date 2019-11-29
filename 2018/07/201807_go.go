package main

import (
	"fmt"
)

func readData() (data [][2]string) {
	var x, y string
	for {
		n, err := fmt.Scanf("Step %s must be finished before step %s can begin.\n", &x, &y)
		if n != 2 || err != nil {
			break
		}
		data = append(data, [2]string{x, y})
	}
	return
}

func main() {
	data := readData()
	requires := make(map[string][]string)
	for _, p := range data {
		requires[p[1]] = append(requires[p[1]], p[0])
	}

	fmt.Println("vim-go", requires)
}
