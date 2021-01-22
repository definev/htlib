// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse and unparse this JSON data, add this code to your project and do:
//
//    user, err := UnmarshalUser(bytes)
//    bytes, err = user.Marshal()

package model

import (
	"time"
)

type User struct {
	ID             string    `json:"id" db:"id, omitempty"`
	Name           string    `json:"name" db:"name, omitempty"`
	Class          string    `json:"class" db:"class, omitempty"`
	Phone          string    `json:"phone" db:"phone, omitempty"`
	Status         string    `json:"status" db:"status, omitempty"`
	CreatedAt      time.Time `json:"-" db:"created_at, omitempty"`
	UpdatedAt      time.Time `json:"-" db:"updated_at, omitempty"`
	BorrowBookList []string  `json:"borrowBookList" db:"borrowBookList, omitempty"`
}
