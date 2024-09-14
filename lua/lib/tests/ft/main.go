package main

import (
	"bytes"
	"fmt"
)

type Server struct {
	Name        string `json:"name"`
	Port        int    `json:"port"`
	EnableLogs  bool   `json:"enable_logs"`
	BaseDomain  string `json:"base_domain"`
	Credentials struct {
		Username string `json:"username"`
		Password string `json:"password"`
	} `json:"credentials"`
}

type User struct {
	Name string
	Age  int
}

// learningn about buffering in go
// implement the io.Writer interface win this struct
type Buffer struct {
	buf []byte
}

func (b *Buffer) Write(p []byte) (n int, err error) {
	b.buf = append(b.buf, p...)
	return len(p), nil
}

func (b *Buffer) String() string {
	return string(b.buf)
}

func main() {
	var buf bytes.Buffer
	fmt.Fprintf(&buf, "one")
	fmt.Println(buf.String())

	b := Buffer{}
	fmt.Fprintf(&b, "two")
	fmt.Println(b.String())
}
