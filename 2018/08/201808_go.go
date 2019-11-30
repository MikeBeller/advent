package main

import (
	"fmt"
)

type Node struct {
	Meta     []int
	Children []*Node
}

func readNum() int {
	var c int
	n, err := fmt.Scan(&c)
	if n != 1 || err != nil {
		panic("WTF?")
	}
	return c
}

func readTree() *Node {
	node := &Node{}
	nNodes := readNum()
	nMeta := readNum()
	for i := 0; i < nNodes; i++ {
		child := readTree()
		node.Children = append(node.Children, child)
	}

	for i := 0; i < nMeta; i++ {
		node.Meta = append(node.Meta, readNum())
	}

	return node

}

func sumMeta(t *Node) int {
	sm := 0
	for _, m := range t.Meta {
		sm += m
	}
	for _, c := range t.Children {
		sm += sumMeta(c)
	}
	return sm
}

func main() {
	t := readTree()
	m := sumMeta(t)
	fmt.Println(m)
}
