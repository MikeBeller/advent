package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

func cancels(x, y byte) bool {
	d := int(x) - int(y)
	return d == 32 || d == -32
}

func react(b []byte) []byte {
	for {
		e := len(b)
		w := 0
		for r := 1; r < len(b); r++ {
			if cancels(b[w], b[r]) {
				if w > 0 {
					w--
				} else {
					r++
					b[w] = b[r]
				}
			} else {
				w++
				b[w] = b[r]
			}
		}
		b = b[0 : w+1]

		if e == len(b) {
			break
		}

	}

	//verify
	for i := 0; i < len(b)-1; i++ {
		if cancels(b[i], b[i+1]) {
			panic("broken")
		}
	}
	return b
}

func main() {
	data, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}
	if data[len(data)-1] == 10 {
		data = data[:len(data)-1]
	}

	// Part 1
	r := make([]byte, len(data))
	copy(r, data)
	r = react(r)
	fmt.Println(len(r))

	// Part 2
	minLen := len(data) + 1
	minPoly := byte(0)
	for _, p := range []byte("ABCDEFGHIJKLMNOPQRSTUVWXYZ") {
		r = r[:0]
		for _, b := range data {
			if b != p && b != p+32 {
				r = append(r, b)
			}
		}
		r = react(r)
		if len(r) < minLen {
			minLen = len(r)
			minPoly = p
		}
	}
	fmt.Printf("%d %c\n", minLen, minPoly)
}
