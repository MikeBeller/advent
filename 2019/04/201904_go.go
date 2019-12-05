package main

import (
	"fmt"
)

func intToDigits(n int) []int {
	r := []int{}
	for i := 100000; i >= 1; i /= 10 {
		var d int
		d, n = n/i, n%i
		r = append(r, d)
	}
	return r
}

func isNondecreasing(ds []int) bool {
	for i := 0; i < 5; i++ {
		if ds[i+1] < ds[i] {
			return false
		}
	}
	return true
}

func runLengths(ns []int) []int {
	lens := []int{1}
	for i := 1; i < len(ns); i++ {
		if ns[i] != ns[i-1] {
			lens = append(lens, 1)
		} else {
			lens[len(lens)-1]++
		}
	}
	return lens
}

func isValid(pwd int) bool {
	ds := intToDigits(pwd)
	if !isNondecreasing(ds) {
		return false
	}
	lens := runLengths(ds)
	for _, l := range lens {
		if l > 1 {
			return true
		}
	}
	return false
}

func partOne(s, e int) int {
	c := 0
	for n := s; n <= e; n++ {
		if isValid(n) {
			c++
		}
	}
	return c
}

func isValid2(pwd int) bool {
	ds := intToDigits(pwd)
	if !isNondecreasing(ds) {
		return false
	}
	lens := runLengths(ds)
	for _, l := range lens {
		if l == 2 {
			return true
		}
	}
	return false
}

func partTwo(s, e int) int {
	c := 0
	for n := s; n <= e; n++ {
		if isValid2(n) {
			c++
		}
	}
	return c
}

func main() {
	fmt.Println(partOne(136818, 685979))
	fmt.Println(partTwo(136818, 685979))
}
