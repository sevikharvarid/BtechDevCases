package domain

import "time"

type User struct {
	ID        string    `json:"id"`        
	Email     string    `json:"email"`
	Password  string    `json:"-"`         
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func NewUser(id, email, hashedPassword string) *User {
	now := time.Now()
	return &User{
		ID:        id,
		Email:     email,
		Password:  hashedPassword,
		CreatedAt: now,
		UpdatedAt: now,
	}
}