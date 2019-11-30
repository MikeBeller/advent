package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

const (
	Null = iota
	Ready
	Working
	Done
)

type Task struct {
	Name           string
	Requires       []*Task
	State          int
	CompletionTime int
}

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

func partOne(tasks map[string]*Task) []string {
	ans := []string{}
	for {
		ts := []string{}
		for _, task := range tasks {
			if task.State == Done {
				continue
			}
			nnd := 0
			for _, tt := range task.Requires {
				if tt.State != Done {
					nnd++
				}
			}
			if nnd == 0 {
				ts = append(ts, task.Name)
			}
		}
		if len(ts) == 0 {
			break
		}

		// Only add the min (could write min loop but i'm lazy)
		sort.StringSlice(ts).Sort()
		ans = append(ans, ts[0])
		tasks[ts[0]].State = Done
	}

	return ans
}

func aToI(s string) int {
	i, err := strconv.Atoi(s)
	if err != nil {
		log.Fatal("invalid integer", s)
	}
	return i
}

func taskDuration(n string, baseTime int) int {
	return int(n[0]) - 64 + baseTime
}

/*
func maxTaskCompletion(n string, tasks map[string]*Task) int {
	mx := -1
	for _, t := range tasks[n].Requires {
		if t.CompletionTime > mx {
			mx = t.CompletionTime
		}
	}
	return mx
}

type Sim struct {
	BaseTime int
	Time     int
	Workers  []*Task
	Queue    []*Task
	Tasks    map[string]*Task
}

func (s *Sim) processTask(n string) {
	task := tasks[n]
	if sim.hasUnsatisfiedDependencies(task) {
		s.advance()
	}
}

func NewSim(baseTime, numWorkers int, tasks map[string]*Task) *Sim {
	return &Sim{BaseTime: baseTime, Workers: make([]*Task, numWorkers), Tasks: tasks}
}
*/

func partTwo(tasks map[string]*Task, baseTime int, numWorkers int) int {
	tm := 0
	for _, t := range tasks {
		t.State = Null
		t.CompletionTime = 0
	}
	ready := []string{}
	working := []string{}
	done := []string{}
	for {
		for _, task := range tasks {
			if task.State == Done || task.State == Working || task.State == Ready {
				continue
			}
			nnd := 0
			for _, tt := range task.Requires {
				if tt.State != Done {
					nnd++
				}
			}
			if nnd == 0 {
				ready = append(ready, task.Name)
				task.State = Ready
			}
		}

		for len(ready) > 0 && len(working) < numWorkers {
			n := ready[0]
			tasks[n].CompletionTime = tm + taskDuration(n, baseTime)
			working = append(working, n)
			tasks[n].State = Working
			ready = ready[1:]
		}

		if len(working) == 0 {
			break
		}
		sort.Slice(working, func(i, j int) bool { return tasks[working[i]].CompletionTime < tasks[working[j]].CompletionTime })
		tasks[working[0]].State = Done
		done = append(done, working[0])
		tm = tasks[working[0]].CompletionTime
		working = working[1:]
	}
	return tm
}

func main() {
	data := readData()
	tasks := make(map[string]*Task)
	for _, p := range data {
		t0, ok := tasks[p[0]]
		if !ok {
			t0 = &Task{Name: p[0]}
			tasks[p[0]] = t0
		}
		t1, ok := tasks[p[1]]
		if !ok {
			t1 = &Task{Name: p[1]}
			tasks[p[1]] = t1
		}
		t1.Requires = append(t1.Requires, t0)
	}

	taskOrder := partOne(tasks)
	fmt.Println("PartOne:", strings.Join(taskOrder, ""))

	baseTime := aToI(os.Args[1])
	numWorkers := aToI(os.Args[2])

	time := partTwo(tasks, baseTime, numWorkers)
	fmt.Println("PartTwo:", time)
}
