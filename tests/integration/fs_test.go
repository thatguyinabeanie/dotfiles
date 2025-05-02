package tests_integration

import (
	"testing"

	"github.com/twpayne/go-vfs/v5/vfst"
)

func TestFileSystemStructure(t *testing.T) {
	fs, cleanup, err := vfst.NewTestFS(map[string]interface{}{
		"/home/user/.config": map[string]interface{}{
			"nvim":    &vfst.Dir{Perm: 0755},
			"nushell": &vfst.Dir{Perm: 0755},
			"tmux":    &vfst.Dir{Perm: 0755},
		},
		"/home/user/source": map[string]interface{}{
			"obsidian": &vfst.Dir{Perm: 0755},
			"personal": &vfst.Dir{Perm: 0755},
			"work":     &vfst.Dir{Perm: 0755},
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	defer cleanup()

	tests := []struct {
		name     string
		path     string
		wantType string
	}{
		// Config directories
		{"Neovim Config Dir", "/home/user/.config/nvim", "dir"},
		{"Nushell Config Dir", "/home/user/.config/nushell", "dir"},
		{"Tmux Config Dir", "/home/user/.config/tmux", "dir"},

		// Source directories
		{"Obsidian Source Dir", "/home/user/source/obsidian", "dir"},
		{"Personal Source Dir", "/home/user/source/personal", "dir"},
		{"Work Source Dir", "/home/user/source/work", "dir"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			info, err := fs.Stat(tt.path)
			if err != nil {
				t.Errorf("Failed to stat %s: %v", tt.path, err)
			}
			if got := info.IsDir(); got != (tt.wantType == "dir") {
				t.Errorf("Wrong type for %s: got %v, want %s", tt.path, got, tt.wantType)
			}
		})
	}
}
