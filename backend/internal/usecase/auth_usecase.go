package usecase

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"

	"github.com/sevikharvarid/BtechDevCases/backend/internal/config"
	"github.com/sevikharvarid/BtechDevCases/backend/internal/domain"
)

var (
	ErrEmailAlreadyExists = errors.New("email already registered")
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrPasswordsMismatch  = errors.New("passwords do not match")
	ErrPasswordTooShort   = errors.New("password must be at least 8 characters")
)

type AuthUsecase struct {
	repo       domain.UserRepository
	jwtService *config.JWTService
}

func NewAuthUsecase(repo domain.UserRepository, jwtService *config.JWTService) *AuthUsecase {
	return &AuthUsecase{
		repo:       repo,
		jwtService: jwtService,
	}
}

type RegisterInput struct {
	Email           string
	Password        string
	ConfirmPassword string
}

func (u *AuthUsecase) Register(input RegisterInput) error {
	if input.Password != input.ConfirmPassword {
		return ErrPasswordsMismatch
	}

	if len(input.Password) < 8 {
		return ErrPasswordTooShort
	}

	if _, err := u.repo.FindByEmail(input.Email); err == nil {
		return ErrEmailAlreadyExists
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

		user := domain.NewUser(
			uuid.New().String(),
			input.Email,
		string(hashedPassword),
	)

	return u.repo.Save(user)
}

type LoginInput struct {
	Email    string
	Password string
}

type LoginResult struct {
	Token string
}

func (u *AuthUsecase) Login(input LoginInput) (*LoginResult, error) {
	user, err := u.repo.FindByEmail(input.Email)
	if err != nil {
		return nil, ErrInvalidCredentials
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
		return nil, ErrInvalidCredentials
	

	token, err := u.jwtService.GenerateToken(user.ID, user.Email)
	if err != nil {
		return nil, err
	}

	return &LoginResult{Token: token}, nil
}