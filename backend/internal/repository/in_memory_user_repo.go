package repository

import (
	"errors"
	"sync"

	"github.com/google/uuid"

	"github.com/sevikharvarid/BtechDevCases/backend/internal/domain"  
)

type InMemoryUserRepository struct {
	users map[string]*domain.User // key: email
	mu    sync.RWMutex
}

func NewInMemoryUserRepository() *InMemoryUserRepository {
	return &InMemoryUserRepository{
		users: make(map[string]*domain.User),
	}
}

func (r *InMemoryUserRepository) FindByEmail(email string) (*domain.User, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	user, exists := r.users[email]
	if !exists {
		return nil, errors.New("user not found")
	}
	return user, nil
}

func (r *InMemoryUserRepository) Save(user *domain.User) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	if _, exists := r.users[user.Email]; exists {
		return errors.New("email already registered")
	}

	r.users[user.Email] = user
	return nil
}