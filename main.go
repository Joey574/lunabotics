package main

import (
	"log"
	"lunabotics/v2/internal/app"
)

func main() {
	a := app.New()
	if err := a.Run(); err != nil {
		log.Fatalln(err)
	}
}
