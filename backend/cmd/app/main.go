package main

import (
	"log"

	"github.com/gofiber/fiber/v3"

	"github.com/sevikharvarid/BtechDevCases/backend/internal/config"
	"github.com/sevikharvarid/BtechDevCases/backend/internal/handler"
	"github.com/sevikharvarid/BtechDevCases/backend/internal/repository"
	"github.com/sevikharvarid/BtechDevCases/backend/internal/usecase"
)

func main() {
	app := fiber.New(fiber.Config{
		AppName:           "JWT Auth Take-Home Backend",
		EnablePrintRoutes: true,
	})

	//* Dependencies
	repo := repository.NewInMemoryUserRepository()
	jwtService := config.NewJWTService()
	authUsecase := usecase.NewAuthUsecase(repo, jwtService)
	authHandler := handler.NewAuthHandler(authUsecase)

	//* Routes
	app.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{"status": "ok"})
	})

	api := app.Group("/api")
	{
		api.Post("/register", authHandler.Register)
		api.Post("/login", authHandler.Login)
	}

	log.Fatal(app.Listen(":8080"))
}