// https://tour.golang.org/moretypes/6
package main

import "fmt"

func main() {
	fmt.Println("Hello, world!")

	var a [2]string    // this is an example of using array --- but remember HW6 ask you for List
	a[0] = "Hello~~~🐈~~~"
	a[1] = "World~~~❤" // I am showing that it automatically supports the special characters
	fmt.Println(a[0], a[1])
	fmt.Println(a)

	primes := [6]int{2, 3, 5, 7, 11, 13} // yes this is how you can define an array with values, but still, HW6 asks for list
	fmt.Println(primes)
}