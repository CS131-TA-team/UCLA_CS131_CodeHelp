/* question: how can we solve Josephus problem in Go?
 * another solution, using structure (not required for HW6) : https://studygolang.com/articles/16623
 */
package main

import (
    "container/list"
    "fmt"
)

func create_list_range(num int) (*list.List) {
    l := list.New()
    for i := 1; i <= num; i += 1 {
        l.PushBack(i)
    }
    return l
}

func rule_out(l *list.List, num int, index int) (*list.List, int) {
    index = (num + index) % l.Len()
    e := l.Front()
    for i := 1; i <= index; i += 1 {
        if i == index {
            fmt.Println("Player", e.Value, "is out.")
            l.Remove(e)
            break
        }
        e = e.Next()
    }
    return l, index
}

func print_list(l *list.List) {
    for e := l.Front(); e != nil; e = e.Next() {
        fmt.Println(e.Value)
    }
}

func main() {
    l := create_list_range(5)
    interval := 3
    index := 0
    // fmt.Println(l)
    // print_list(l)

    for {
        if l.Len() == 1 {
            fmt.Println("Player", l.Front().Value, "wins!")
            break
        }
        l, index = rule_out(l, interval, index)
        //print_list(l)
        //fmt.Println(index)
        // break
    }
}

