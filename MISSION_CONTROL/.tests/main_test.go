package tests

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"
)

func TestMain(m *testing.M) {
	// Get the current working directory
	cwd, err := os.Getwd()
	if err != nil {
		fmt.Printf("Failed to get current working directory: %v\n", err)
		os.Exit(1)
	}

	// If we're in the .tests directory, we need to navigate to the project root
	if filepath.Base(cwd) == ".tests" {
		// We're already in the right place, no need to change directory
	} else {
		// Try to find the root directory
		dirs := []string{".", "..", "../.."}
		found := false
		for _, dir := range dirs {
			if _, err := os.Stat(filepath.Join(dir, "MISSION_CONTROL/dot_config")); err == nil {
				if err := os.Chdir(dir); err != nil {
					fmt.Printf("Failed to change directory to %s: %v\n", dir, err)
					os.Exit(1)
				}
				found = true
				break
			}
		}
		if !found {
			fmt.Println("Could not find project root directory")
			os.Exit(1)
		}
	}

	code := m.Run()
	os.Exit(code)
}

func TestConfigDirectoryStructure(t *testing.T) {
	// Get the current working directory
	cwd, err := os.Getwd()
	if err != nil {
		t.Fatalf("Failed to get current working directory: %v", err)
	}

	// Navigate up one directory if we're in the .tests directory
	var rootDir string
	if filepath.Base(cwd) == ".tests" {
		rootDir = filepath.Dir(filepath.Dir(cwd))
	} else {
		rootDir = filepath.Dir(cwd)
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

	// Navigate up one directory if we're in the .tests directory
	var rootDir string
	if filepath.Base(cwd) == ".tests" {
		rootDir = filepath.Dir(filepath.Dir(cwd))
	} else {
		rootDir = filepath.Dir(cwd)
	}

	sourcePath := filepath.Join(rootDir, "MISSION_CONTROL", "source")
	if _, err := os.Stat(sourcePath); os.IsNotExist(err) {
		t.Fatalf("Source directory not found at %s", sourcePath)
	}

	sourceDirs := []string{
		"obsidian",
		"personal",
		"work",
		"fun",
		"pokemon",
	}

	for _, dir := range sourceDirs {
		path := filepath.Join(sourcePath, dir)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("Expected source directory %s to exist", path)
		}
	}
}
