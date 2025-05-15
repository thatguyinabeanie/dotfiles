package tests

import (
	"os"
	"path/filepath"
	"testing"
)

func init() {
	// Get the current working directory
	cwd, err := os.Getwd()
	if err != nil {
		panic(err)
	}

	// If we're in the __tests__ directory, we need to navigate to the project root
	if filepath.Base(cwd) == "__tests__" {
		err = os.Chdir("..")
		if err != nil {
			panic(err)
		}
	}
}

func TestMain(m *testing.M) {
	// Run tests
	code := m.Run()

	// Exit with the test result code
	os.Exit(code)
}

func TestConfigDirectoryStructure(t *testing.T) {
	// Get the current working directory
	cwd, err := os.Getwd()
	if err != nil {
		t.Fatalf("Failed to get current working directory: %v", err)
	}

	// Navigate up one directory if we're in the __tests__ directory
	var rootDir string
	if filepath.Base(cwd) == "__tests__" {
		rootDir = filepath.Dir(cwd)
	} else {
		rootDir = cwd
	}

	configPath := filepath.Join(rootDir, "MISSION_CONTROL", "dot_config")
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		t.Fatalf("Config directory not found at %s", configPath)
	}

	configDirs := []string{
		"nvim",
		"nushell",
		"tmux",
		"mise",
		"git",
	}

	for _, dir := range configDirs {
		path := filepath.Join(configPath, dir)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("Expected config directory %s to exist", path)
		}
	}
}

func TestSourceDirectoryStructure(t *testing.T) {
	// Get the current working directory
	cwd, err := os.Getwd()
	if err != nil {
		t.Fatalf("Failed to get current working directory: %v", err)
	}

	// Navigate up one directory if we're in the __tests__ directory
	var rootDir string
	if filepath.Base(cwd) == "__tests__" {
		rootDir = filepath.Dir(cwd)
	} else {
		rootDir = cwd
	}

	// Verify the source directory exists
	sourcePath := filepath.Join(rootDir, "MISSION_CONTROL", "source")
	if _, err := os.Stat(sourcePath); os.IsNotExist(err) {
		t.Fatalf("Source directory not found at %s", sourcePath)
	}

	// Verify the source directory has a valid .chezmoiexternal.toml.tmpl file
	// This file defines the repositories that will be cloned into the source directory
	externalConfigPath := filepath.Join(sourcePath, ".chezmoiexternal.toml.tmpl")
	if _, err := os.Stat(externalConfigPath); os.IsNotExist(err) {
		t.Errorf("Expected .chezmoiexternal.toml.tmpl file not found at %s", externalConfigPath)
	}

	// Check that the source directory is properly configured in the repository
	// This test doesn't verify the actual subdirectories since they are created
	// by chezmoi apply, but it ensures the source directory itself exists and is
	// properly configured with external repositories
	t.Logf("Source directory structure verified at %s", sourcePath)
}
