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
}

func testObsidianRepos(t *testing.T) {
	repos := []string{
		"obsidian-vault",
		"obsidian-vault-work",
		"bramses/bramses-highly-opinionated-vault-2023",
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
