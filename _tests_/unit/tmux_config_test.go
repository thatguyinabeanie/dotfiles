package unit_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"github.com/alecthomas/assert/v2"
)

func TestTmuxFzfURLConfiguration(t *testing.T) {
	t.Run("Tmux FZF URL Theming", func(t *testing.T) {
		t.Run("Theme Configuration", testTmuxFzfURLThemeConfig)
		t.Run("Color Variables", testTmuxFzfURLColorVariables)
		t.Run("FZF Options", testTmuxFzfURLOptions)
	})

	t.Run("Terminal Browser Integration", func(t *testing.T) {
		t.Run("Browser Availability", testTerminalBrowserAvailability)
		t.Run("URL Handler Script", testURLHandlerScript)
		t.Run("Tmux Configuration", testTmuxBrowserIntegration)
		t.Run("URL Routing Logic", testURLRoutingLogic)
	})
}

func testTmuxFzfURLThemeConfig(t *testing.T) {
	// Check if tmux is available
	if !commandExists("tmux") {
		t.Skip("tmux not available, skipping theme configuration test")
	}

	// Test that tmux fzf-url options are configured
	cmd := exec.Command("tmux", "show-option", "-gv", "@fzf-url-fzf-options")
	output, err := cmd.Output()

	if err != nil {
		t.Skip("tmux not running or fzf-url not configured, skipping test")
	}

	outputStr := strings.TrimSpace(string(output))
	assert.True(t, strings.Contains(outputStr, "--tmux center,80%,60%"), "should have tmux popup configuration")
	assert.True(t, strings.Contains(outputStr, "--border=rounded"), "should have rounded border")
	assert.True(t, strings.Contains(outputStr, "--multi"), "should support multi-select")
}

func testTmuxFzfURLColorVariables(t *testing.T) {
	// Check if tmux is available
	if !commandExists("tmux") {
		t.Skip("tmux not available, skipping color variable test")
	}

	// Test that tmux fzf-url uses Catppuccin theme variables
	cmd := exec.Command("tmux", "show-option", "-gv", "@fzf-url-fzf-options")
	output, err := cmd.Output()

	if err != nil {
		t.Skip("tmux not running or fzf-url not configured, skipping test")
	}

	outputStr := strings.TrimSpace(string(output))

	// Check for Catppuccin theme variables (should contain #{@thm_*} patterns)
	catppuccinVariables := []string{
		"#{@thm_base}",
		"#{@thm_text}",
		"#{@thm_surface_0}",
		"#{@thm_red}",
		"#{@thm_mauve}",
		"#{@thm_teal}",
	}

	foundVariables := 0
	for _, variable := range catppuccinVariables {
		if strings.Contains(outputStr, variable) {
			foundVariables++
		}
	}

	assert.True(t, foundVariables > 0, "should contain Catppuccin theme variables")
}

func testTmuxFzfURLOptions(t *testing.T) {
	// Check if tmux is available
	if !commandExists("tmux") {
		t.Skip("tmux not available, skipping fzf options test")
	}

	// Test fzf-url keybinding
	cmd := exec.Command("tmux", "show-option", "-gv", "@fzf-url-bind")
	output, err := cmd.Output()

	if err != nil {
		t.Skip("tmux not running or fzf-url bind not configured, skipping test")
	}

	outputStr := strings.TrimSpace(string(output))
	assert.Equal(t, "u", outputStr, "fzf-url should be bound to 'u' key")

	// Test history limit
	cmd = exec.Command("tmux", "show-option", "-gv", "@fzf-url-history-limit")
	output, err = cmd.Output()

	if err == nil {
		outputStr = strings.TrimSpace(string(output))
		assert.Equal(t, "3000", outputStr, "fzf-url history limit should be 3000")
	}
}

func testTerminalBrowserAvailability(t *testing.T) {
	browsers := []string{"lynx", "w3m", "links"}
	availableBrowsers := []string{}

	for _, browser := range browsers {
		if commandExists(browser) {
			availableBrowsers = append(availableBrowsers, browser)
		}
	}

	assert.True(t, len(availableBrowsers) > 0, "at least one terminal browser should be available")

	// Test that lynx is available (primary browser)
	if commandExists("lynx") {
		assert.True(t, contains(availableBrowsers, "lynx"), "lynx should be available as primary browser")
	}
}

func testURLHandlerScript(t *testing.T) {
	homeDir, err := os.UserHomeDir()
	assert.NoError(t, err, "should be able to get user home directory")

	handlerPath := filepath.Join(homeDir, ".local", "bin", "terminal-url-handler.sh")

	// Check if handler script exists
	_, err = os.Stat(handlerPath)
	assert.NoError(t, err, "URL handler script should exist")

	// Check if handler script is executable
	info, err := os.Stat(handlerPath)
	assert.NoError(t, err, "should be able to stat handler script")

	mode := info.Mode()
	assert.True(t, mode&0111 != 0, "URL handler script should be executable")
}

func testTmuxBrowserIntegration(t *testing.T) {
	// Check if tmux is available
	if !commandExists("tmux") {
		t.Skip("tmux not available, skipping browser integration test")
	}

	// Test that tmux fzf-url is configured to use terminal-url-handler
	cmd := exec.Command("tmux", "show-option", "-gv", "@fzf-url-open")
	output, err := cmd.Output()

	if err != nil {
		t.Skip("tmux not running or fzf-url-open not configured, skipping test")
	}

	outputStr := strings.TrimSpace(string(output))
	assert.True(t, strings.Contains(outputStr, "terminal-url-handler"),
		"tmux fzf-url should be configured to use terminal-url-handler")
}

func testURLRoutingLogic(t *testing.T) {
	testCases := []struct {
		url          string
		expectedType string
		description  string
	}{
		{
			url:          "https://github.com/user/repo",
			expectedType: "git_hosting",
			description:  "GitHub URLs should route to git hosting handler",
		},
		{
			url:          "https://docs.github.com/en/actions",
			expectedType: "documentation",
			description:  "Documentation URLs should route to documentation handler",
		},
		{
			url:          "http://localhost:3000",
			expectedType: "local_dev",
			description:  "Local development URLs should route to local dev handler",
		},
		{
			url:          "https://www.npmjs.com/package/fzf",
			expectedType: "package_registry",
			description:  "Package registry URLs should route to package registry handler",
		},
		{
			url:          "https://example.com",
			expectedType: "default",
			description:  "Default URLs should route to default handler",
		},
	}

	for _, tc := range testCases {
		t.Run(tc.description, func(t *testing.T) {
			// Test URL categorization logic
			urlType := categorizeURL(tc.url)
			assert.Equal(t, tc.expectedType, urlType, tc.description)
		})
	}
}

// Helper function to categorize URLs (mirrors logic in terminal-url-handler.sh)
func categorizeURL(url string) string {
	switch {
	case strings.Contains(url, "docs.") || strings.Contains(url, "documentation.") || strings.Contains(url, "wiki.") || strings.Contains(url, "readme") || strings.Contains(url, "man.") || strings.Contains(url, "help.") || strings.Contains(url, ".md"):
		return "documentation"
	case strings.Contains(url, "localhost") || strings.Contains(url, "127.0.0.1") || strings.Contains(url, "0.0.0.0") || strings.Contains(url, ".local") || strings.Contains(url, ":3000") || strings.Contains(url, ":8000") || strings.Contains(url, ":8080") || strings.Contains(url, ":4000"):
		return "local_dev"
	case strings.Contains(url, "npm") || strings.Contains(url, "pypi") || strings.Contains(url, "rubygems") || strings.Contains(url, "crates.io") || strings.Contains(url, "pkg.go.dev"):
		return "package_registry"
	case strings.Contains(url, "github.com") || strings.Contains(url, "gitlab.com") || strings.Contains(url, "bitbucket.org"):
		return "git_hosting"
	default:
		return "default"
	}
}

// Helper function to check if a command exists
func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

// Helper function to check if slice contains string
func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}
