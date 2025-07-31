//go:build !windows

package util

import "syscall"

func GetAttr() syscall.SysProcAttr {
	return syscall.SysProcAttr{}
}
