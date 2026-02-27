package handler

import (
	"github.com/gofiber/fiber/v3"

	"github.com/sevikharvarid/BtechDevCases/backend/internal/usecase"

)

type AuthHandler struct {
	usecase *usecase.AuthUsecase
}

func NewAuthHandler(usecase *usecase.AuthUsecase) *AuthHandler {
	return &AuthHandler{usecase: usecase}
}

func (h *AuthHandler) Register(c fiber.Ctx) error {
	var input usecase.RegisterInput
	if err := c.Bind().JSON(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
	}

	err := h.usecase.Register(input)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"message": "User registered successfully"})
}

func (h *AuthHandler) Login(c fiber.Ctx) error {
	var input usecase.LoginInput
	if err := c.Bind().JSON(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
	}

	result, err := h.usecase.Login(input)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"token": result.Token})
}