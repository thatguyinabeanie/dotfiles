// Package helpers provides utility functions for testing.
package helpers

import (
	"os"
	"path/filepath"
	"testing"
)

// TestConfig represents the test configuration
type TestConfig struct {
	HomeDir     string
	ConfigDir   string
	WorkEnv     bool
	GitUsername string
}

// NewTestConfig creates a new test configuration
func NewTestConfig(t *testing.T) *TestConfig {
	t.Helper()

	tmpDir := t.TempDir()
	homeDir := filepath.Join(tmpDir, "home")
	configDir := filepath.Join(homeDir, ".config")

	// Create necessary directories
	dirs := []string{
		homeDir,
		configDir,
		filepath.Join(configDir, "nvim"),
		filepath.Join(configDir, "nushell"),
		filepath.Join(configDir, "obsidian"),
	}

	for _, dir := range dirs {
		if err := os.MkdirAll(dir, 0750); err != nil {
			t.Fatalf("Failed to create directory %s: %v", dir, err)
		}
	}

	return &TestConfig{
		HomeDir:     homeDir,
		ConfigDir:   configDir,
		WorkEnv:     false,
		GitUsername: "thatguyinabeanie",
	}
}

// SetWorkEnv sets the work environment flag
func (tc *TestConfig) SetWorkEnv(workEnv bool) {
	tc.WorkEnv = workEnv
}

// CreateDir creates a directory with the given path.
func CreateDir(dir string) error {
	if err := os.MkdirAll(dir, 0750); err != nil {
		return err
	}
	return nil
}
