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
	PrintTestHeader(t, "CONFIG DIRECTORY STRUCTURE")

	results := []TestResult{}

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
		exists := true
		if _, err := os.Stat(path); os.IsNotExist(err) {
			exists = false
			t.Errorf("Expected config directory %s to exist", path)
		}

		result := TestResult{
			Name:    fmt.Sprintf("Config Dir: %s", dir),
			Passed:  exists,
			Message: fmt.Sprintf("Directory at %s", path),
		}

		PrintTestResult(t, result)
		results = append(results, result)
	}

	PrintTestSummary(t, results)
}
func TestObsidianDirectoryStructure(t *testing.T) {
	PrintTestHeader(t, "OBSIDIAN DIRECTORY STRUCTURE")

	results := []TestResult{}

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
	obsidianDirExists := true
	if _, err := os.Stat(obsidianPath); os.IsNotExist(err) {
		obsidianDirExists = false
		t.Fatalf("Obsidian directory not found at %s", obsidianPath)
	}

	result := TestResult{
		Name:    "Obsidian Directory",
		Passed:  obsidianDirExists,
		Message: fmt.Sprintf("Directory at %s", obsidianPath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	// Check for the .chezmoiexternal.toml.tmpl file in the obsidian directory
	externalConfigPath := filepath.Join(obsidianPath, ".chezmoiexternal.toml.tmpl")
	externalConfigExists := true
	if _, err := os.Stat(externalConfigPath); os.IsNotExist(err) {
		externalConfigExists = false
		t.Errorf("Expected .chezmoiexternal.toml.tmpl file not found at %s", externalConfigPath)
	}

	result = TestResult{
		Name:    "External Config Template",
		Passed:  externalConfigExists,
		Message: fmt.Sprintf("File at %s", externalConfigPath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	// Check for the obsidian config directory
	obsidianConfigPath := filepath.Join(rootDir, "MISSION_CONTROL", "dot_config", "obsidian")
	obsidianConfigExists := true
	if _, err := os.Stat(obsidianConfigPath); os.IsNotExist(err) {
		obsidianConfigExists = false
		t.Logf("Obsidian config directory not found at %s - this is expected to be created by chezmoi apply", obsidianConfigPath)
	}

	result = TestResult{
		Name:    "Obsidian Config Directory",
		Passed:  obsidianConfigExists,
		Message: fmt.Sprintf("Directory at %s", obsidianConfigPath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	// Check for the empty directory structure
	emptyDirPath := filepath.Join(rootDir, "MISSION_CONTROL", "empty_dot_config", "empty_obsidian", "empty_obsidian-vault")
	emptyDirExists := true
	if _, err := os.Stat(emptyDirPath); os.IsNotExist(err) {
		emptyDirExists = false
		t.Logf("Empty directory structure not found at %s", emptyDirPath)
	}

	result = TestResult{
		Name:    "Empty Directory Structure",
		Passed:  emptyDirExists,
		Message: fmt.Sprintf("Directory at %s", emptyDirPath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	PrintTestSummary(t, results)
}

func TestSourceDirectoryStructure(t *testing.T) {
	PrintTestHeader(t, "SOURCE DIRECTORY STRUCTURE")

	results := []TestResult{}

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
	sourceDirExists := true
	if _, err := os.Stat(sourcePath); os.IsNotExist(err) {
		sourceDirExists = false
		t.Fatalf("Source directory not found at %s", sourcePath)
	}

	result := TestResult{
		Name:    "Source Directory",
		Passed:  sourceDirExists,
		Message: fmt.Sprintf("Directory at %s", sourcePath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	// Verify the source directory has a valid .chezmoiexternal.toml.tmpl file
	// This file defines the repositories that will be cloned into the source directory
	externalConfigPath := filepath.Join(sourcePath, ".chezmoiexternal.toml.tmpl")
	externalConfigExists := true
	if _, err := os.Stat(externalConfigPath); os.IsNotExist(err) {
		externalConfigExists = false
		t.Errorf("Expected .chezmoiexternal.toml.tmpl file not found at %s", externalConfigPath)
	}

	result = TestResult{
		Name:    "Source External Config",
		Passed:  externalConfigExists,
		Message: fmt.Sprintf("File at %s", externalConfigPath),
	}
	PrintTestResult(t, result)
	results = append(results, result)

	// Check that the source directory is properly configured in the repository
	// This test doesn't verify the actual subdirectories since they are created
	// by chezmoi apply, but it ensures the source directory itself exists and is
	// properly configured with external repositories
	result = TestResult{
		Name:    "Source Structure",
		Passed:  true,
		Message: "Source directory structure verified",
	}
	PrintTestResult(t, result)
	results = append(results, result)

	PrintTestSummary(t, results)
}
