package main

import "fmt"

func main() {
	_, err := fmt.Println("Hello World!")
	if err != nil {
		panic(err)
	}
}
