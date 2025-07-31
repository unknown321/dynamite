package main

import (
	"dynamite/cli"
)

//go:generate go run moddata/coop_essentials/generate.go
//go:generate go run webui/docs/main.go

func main() {
	cli.Run()
}
