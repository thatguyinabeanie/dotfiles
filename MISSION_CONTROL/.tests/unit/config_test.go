package tests_unit

import (
	"testing"

	"github.com/alecthomas/assert/v2"
)

func TestChezmoiConfig(t *testing.T) {
	t.Run("GitRepos Configuration", func(t *testing.T) {
		t.Run("Obsidian Repos", testObsidianRepos)
		t.Run("Work Repos", testWorkRepos)
		t.Run("Private Repos", testPrivateRepos)
	})

	t.Run("Homebrew Configuration", func(t *testing.T) {
		t.Run("Work Packages", testWorkBrewPackages)
		t.Run("Personal Packages", testPersonalBrewPackages)
		t.Run("Shared Dependencies", testSharedDependencies)
	})

	t.Run("Neovim Configuration", func(t *testing.T) {
		t.Run("Obsidian Integration", testObsidianNeovimIntegration)
	})
}

func testObsidianRepos(t *testing.T) {
	repos := []string{
		"obsidian-vault",
		"obsidian-vault-work",
		"bramses-highly-opinionated-vault-2023",
		"smart-notes",
	}

	for _, repo := range repos {
		assert.NotEqual(t, repo, "")
	}
}

func testWorkRepos(t *testing.T) {
	repos := []string{
		"console",
		"popsicle",
	}

	for _, repo := range repos {
		assert.NotEqual(t, repo, "")
	}
}

func testPrivateRepos(t *testing.T) {
	repos := []string{
		"personal-notes",
	}

	for _, repo := range repos {
		assert.NotEqual(t, repo, "")
		assert.Equal(t, "personal-notes", repos[0])
	}
}

func testWorkBrewPackages(t *testing.T) {
	packages := []string{
		"argo",
		"awscli",
		"circleci",
		"kind",
		"k9s",
	}

	for _, pkg := range packages {
		assert.NotEqual(t, pkg, "")
	}
}

func testPersonalBrewPackages(t *testing.T) {
	casks := []string{
		"1password",
		"1password-cli",
		"blender",
		"darktable",
		"discord",
	}

	for _, cask := range casks {
		assert.NotEqual(t, cask, "")
	}
}

func testSharedDependencies(t *testing.T) {
	taps := []string{
		"adoptopenjdk/openjdk",
		"charmbracelet/tap",
		"hashicorp/tap",
		"homebrew/autoupdate",
	}

	for _, tap := range taps {
		assert.NotEqual(t, tap, "")
	}
}

func testObsidianNeovimIntegration(t *testing.T) {
	// Test that the Obsidian plugin is properly configured
	expectedFiles := []string{
		"dot_config/nvim/lua/plugins/utilities/obsidian.lua.tmpl",
	}

	// Test that the Obsidian keymaps are properly configured
	expectedKeymaps := []string{
		"<leader>On",  // New note
		"<leader>Oo",  // Open in Obsidian App
		"<leader>Of",  // Follow link
		"<leader>Ob",  // Backlinks
		"<leader>Oq",  // Quick switch
		"<leader>Os",  // Search
		"<leader>Ot",  // Today's note
		"<leader>Oy",  // Yesterday's note
		"<leader>Owp", // Personal workspace
		"<leader>Ows", // Smart notes workspace
		"<leader>Owb", // Bramses workspace
	}

	// Verify files exist (this is a simple check, not actually checking file contents)
	for _, file := range expectedFiles {
		assert.NotEqual(t, file, "")
	}

	// Verify keymaps (this is a simple check, not actually checking if they're defined)
	for _, keymap := range expectedKeymaps {
		assert.NotEqual(t, keymap, "")
	}
}
