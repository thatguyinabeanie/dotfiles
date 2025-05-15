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
	// PrintTestHeader(t, "CONFIG DIRECTORY STRUCTURE")

	// results := []TestResult{}

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
		"obsidian",
	}

	for _, dir := range configDirs {
		path := filepath.Join(configPath, dir)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("Expected config directory %s to exist", path)
		}
	}

	// PrintTestSummary(t, results)
}

func TestObsidianDirectoryStructure(t *testing.T) {
	// PrintTestHeader(t, "OBSIDIAN DIRECTORY STRUCTURE")

	// results := []TestResult{}

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
	}

	// Check for the empty directory structure
	emptyDirPath := filepath.Join(rootDir, "MISSION_CONTROL", "empty_dot_config", "empty_obsidian", "empty_obsidian-vault")
	if _, err := os.Stat(emptyDirPath); os.IsNotExist(err) {
		t.Logf("Empty directory structure not found at %s", emptyDirPath)
	}

	// PrintTestSummary(t, results)
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

	// Try multiple possible paths for the source directory
	possiblePaths := []string{
		filepath.Join(rootDir, "MISSION_CONTROL", "source"),
		filepath.Join(rootDir, "source"),
		"source",                 // Add relative path
		"MISSION_CONTROL/source", // Add relative path with MISSION_CONTROL
	}

	var sourcePath string
	var found bool
	for _, path := range possiblePaths {
		if _, err := os.Stat(path); err == nil {
			sourcePath = path
			found = true
			break
		}
	}

	if !found {
		t.Fatalf("Source directory not found in any of the expected locations: %v", possiblePaths)
	}

	// Verify the source directory exists and is a directory
	info, err := os.Stat(sourcePath)
	if err != nil {
		t.Fatalf("Failed to stat source directory: %v", err)
	}
	if !info.IsDir() {
		t.Fatalf("Source path exists but is not a directory: %s", sourcePath)
	}
}
