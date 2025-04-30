package tests

import (
	"os"
	"path/filepath"
	"testing"
)

func TestMain(m *testing.M) {
	// Change to the root directory of the project if needed
	if _, err := os.Stat("ROOT/dot_config"); os.IsNotExist(err) {
		// Try to find the root directory
		dirs := []string{".", "..", "../.."}
		for _, dir := range dirs {
			if _, err := os.Stat(filepath.Join(dir, "ROOT/dot_config")); err == nil {
				// Do this:
				if err := os.Chdir(dir); err != nil {
					os.Exit(1)
				}
				break
			}
		}
	}
	code := m.Run()
	os.Exit(code)
}

func TestConfigDirectoryStructure(t *testing.T) {
	// First verify we're in the right directory
	if _, err := os.Stat("ROOT/dot_config"); os.IsNotExist(err) {
		t.Fatal("Test must be run from the project root directory containing ROOT/dot_config")
	}

	configDirs := []string{
		"nvim",
		"nushell",
		"obsidian",
		"tmux",
		"mise",
		"git",
	}

	for _, dir := range configDirs {
		path := filepath.Join("ROOT/dot_config", dir)
		if _, err := os.Stat(path); os.IsNotExist(err) {
			t.Errorf("Expected config directory %s to exist", path)
		}
	}
}
