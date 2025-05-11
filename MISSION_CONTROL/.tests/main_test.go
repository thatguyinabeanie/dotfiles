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
		"obsidian",
	}

	for _, dir := range configDirs {
		path := filepath.Join(configPath, dir)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("Expected config directory %s to exist", path)
		}
	}
}
func TestObsidianDirectoryStructure(t *testing.T) {
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

	// Check for the obsidian directory in MISSION_CONTROL
	obsidianPath := filepath.Join(rootDir, "MISSION_CONTROL", "obsidian")
	if _, err := os.Stat(obsidianPath); os.IsNotExist(err) {
		t.Fatalf("Obsidian directory not found at %s", obsidianPath)
	}

	// Check for the .chezmoiexternal.toml.tmpl file in the obsidian directory
	externalConfigPath := filepath.Join(obsidianPath, ".chezmoiexternal.toml.tmpl")
	if _, err := os.Stat(externalConfigPath); os.IsNotExist(err) {
		t.Errorf("Expected .chezmoiexternal.toml.tmpl file not found at %s", externalConfigPath)
	}

	// Check for the obsidian config directory
	obsidianConfigPath := filepath.Join(rootDir, "MISSION_CONTROL", "dot_config", "obsidian")
	if _, err := os.Stat(obsidianConfigPath); os.IsNotExist(err) {
		t.Logf("Obsidian config directory not found at %s - this is expected to be created by chezmoi apply", obsidianConfigPath)
	} else {
		t.Logf("Obsidian config directory found at %s", obsidianConfigPath)
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
