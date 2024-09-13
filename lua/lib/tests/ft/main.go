package main

import "fmt"

func main() {
	_, err := fmt.Println("hello")
	if err != nil {
		panic(err)
	}
}
