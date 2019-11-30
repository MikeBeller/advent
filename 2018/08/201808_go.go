package main

import "fmt"

func main() {
	r := []int{}
	for {
		var c int
		n, err := fmt.Scan(&c)
		if n != 1 || err != nil {
			break
		}
		r = append(r, c)
	}
	fmt.Println(r)
}
