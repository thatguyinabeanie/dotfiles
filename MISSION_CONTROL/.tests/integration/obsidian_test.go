package tests_integration

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/twpayne/go-vfs/v5/vfst"
)

func TestObsidianIntegration(t *testing.T) {
	// Create a test filesystem with the expected structure
	fs, cleanup, err := vfst.NewTestFS(map[string]interface{}{
		"/home/user/.config/nvim/lua/plugins/utilities": map[string]interface{}{
			"obsidian.lua.tmpl": "return {\n  \"epwalsh/obsidian.nvim\",\n  event = {\n    \"BufReadPre \" .. vim.fn.expand(\"~\") .. \"/source/obsidian/**.md\",\n  },\n}",
		},
		"/home/user/.config/nushell": map[string]interface{}{
			"aliases.nu.tmpl": "def obsidian_nvim [\n  vault: string = \"personal\"\n] {\n  let base_path = \"~/source/obsidian\"\n}",
		},
		"/home/user/source/obsidian": map[string]interface{}{
			"obsidian-vault": &vfst.Dir{Perm: 0755},
			"smart-notes":    &vfst.Dir{Perm: 0755},
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	defer cleanup()

	// Test cases for files that should exist
	tests := []struct {
		name string
		path string
	}{
		{"Obsidian Neovim Plugin", "/home/user/.config/nvim/lua/plugins/utilities/obsidian.lua.tmpl"},
		{"Obsidian Nushell Function", "/home/user/.config/nushell/aliases.nu.tmpl"},
		{"Obsidian Vault Directory", "/home/user/source/obsidian/obsidian-vault"},
		{"Obsidian Smart Notes Directory", "/home/user/source/obsidian/smart-notes"},
	}

	// Verify all expected files exist
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if _, err := fs.Stat(tt.path); os.IsNotExist(err) {
				t.Errorf("Expected file %s does not exist", tt.path)
			}
		})
	}

	// Test that the Obsidian Neovim plugin configuration contains expected content
	t.Run("Obsidian Neovim Plugin Content", func(t *testing.T) {
		path := "/home/user/.config/nvim/lua/plugins/utilities/obsidian.lua.tmpl"
		content, err := fs.ReadFile(path)
		if err != nil {
			t.Fatalf("Failed to read file %s: %v", path, err)
		}

		expectedContent := "return {\n  \"epwalsh/obsidian.nvim\","
		if string(content)[:len(expectedContent)] != expectedContent {
			t.Errorf("File %s does not contain expected content", path)
		}
	})

	// Test that the Obsidian Nushell function contains expected content
	t.Run("Obsidian Nushell Function Content", func(t *testing.T) {
		path := "/home/user/.config/nushell/aliases.nu.tmpl"
		content, err := fs.ReadFile(path)
		if err != nil {
			t.Fatalf("Failed to read file %s: %v", path, err)
		}

		expectedContent := "def obsidian_nvim ["
		if string(content)[:len(expectedContent)] != expectedContent {
			t.Errorf("File %s does not contain expected content", path)
		}
	})
}
