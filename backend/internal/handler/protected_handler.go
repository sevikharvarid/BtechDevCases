package handler

import (
	"github.com/gofiber/fiber/v3"

	"github.com/sevikharvarid/BtechDevCases/backend/internal/config"
)

type ProtectedHandler struct {
	jwtService *config.JWTService
}

func NewProtectedHandler(jwtService *config.JWTService) *ProtectedHandler {
	return &ProtectedHandler{jwtService: jwtService}
}

func (h *ProtectedHandler) Protected(c fiber.Ctx) error {
	claims := c.Locals("user").(*config.CustomClaims)
	if claims == nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": "user not found in context"})
	}

	message := "Hello " + claims.Email + ", welcome back"
	return c.JSON(fiber.Map{"message": message})
}