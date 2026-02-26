package config

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type CustomClaims struct {
	UserID string `json:"sub"`   // user identifier
	Email  string `json:"email"`
	jwt.RegisteredClaims
}

type JWTService struct {
	secret []byte
}

func NewJWTService() *JWTService {
	secret := []byte(os.Getenv("JWT_SECRET"))
	if len(secret) == 0 {
		secret = []byte("supersecretkeyfor-takehome-only-change-in-prod")
	}
	return &JWTService{secret: secret}
}

func (s *JWTService) GenerateToken(userID, email string) (string, error) {
	claims := CustomClaims{
		UserID: userID,
		Email:  email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(s.secret)
}

func (s *JWTService) ValidateToken(tokenString string) (*CustomClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("unexpected signing method")
		}
		return s.secret, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*CustomClaims); ok && token.Valid {
		return claims, nil
	}
	return nil, errors.New("invalid token")
}