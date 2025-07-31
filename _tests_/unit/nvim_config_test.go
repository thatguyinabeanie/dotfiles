// nolint:gosec
package unit_test

import (
	"os"
	"path/filepath"
	"testing"
)

// Simplified tests for the new structure
func TestNvimConfigStructure(t *testing.T) {
	t.Run("Core plugins exist", func(t *testing.T) {
		corePlugins := []string{
			"completions.lua",
			"language-tooling.lua",
			"neotest.lua",
			"nvim-dap.lua",
			"blame.lua",
			"lazydev.lua",
		}

		for _, plugin := range corePlugins {
			path := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "core", plugin)
			if _, err := os.Stat(path); os.IsNotExist(err) {
				t.Errorf("Core plugin %s should exist", plugin)
			}
		}
	})
}
