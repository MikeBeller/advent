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

func main() {
	b, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}
	if b[len(b)-1] == 10 {
		b = b[:len(b)-1]
	}

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

	fmt.Println(len(b))
}
