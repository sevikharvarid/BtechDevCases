package main

import (
	"log"

	"github.com/gofiber/fiber/v3"
)

func main() {
	app := fiber.New(fiber.Config{
		AppName: "JWT Auth Take-Home Backend",
	})


	log.Fatal(app.Listen(":8080"))
}