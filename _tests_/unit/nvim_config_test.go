// nolint:gosec
package unit_test

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

// TestNvimPluginLazyLoading verifies that plugins are correctly configured for lazy loading
func TestNvimPluginLazyLoading(t *testing.T) {
	t.Run("AI plugins lazy loading", func(t *testing.T) {
		// Plugins that should be lazy loaded
		lazyPlugins := map[string][]string{
			"codecompanion.lua": {"lazy = true", "cmd =", "keys ="},
			"copilot.lua":       {"lazy = true", "event = \"InsertEnter\""},
			"copilot-chat.lua":  {"lazy = true"},
		}

		// Plugins that should NOT be lazy loaded
		eagerPlugins := []string{
			"avante.lua",
			"claude-code.lua",
		}

		pluginPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "llm")

		// Check lazy loaded plugins
		for file, patterns := range lazyPlugins {
			path := filepath.Join(pluginPath, file)
			content, err := os.ReadFile(path)
			if err != nil {
				t.Errorf("Failed to read %s: %v", file, err)
				continue
			}

			for _, pattern := range patterns {
				if !strings.Contains(string(content), pattern) {
					t.Errorf("%s should contain '%s' for lazy loading", file, pattern)
				}
			}
		}

		// Check eager loaded plugins
		for _, file := range eagerPlugins {
			path := filepath.Join(pluginPath, file)
			content, err := os.ReadFile(path)
			if err != nil {
				t.Errorf("Failed to read %s: %v", file, err)
				continue
			}

			if strings.Contains(string(content), "lazy = true") {
				t.Errorf("%s should NOT be lazy loaded", file)
			}
		}
	})

	t.Run("Development tools lazy loading", func(t *testing.T) {
		devPlugins := map[string][]string{
			"overseer.lua": {"lazy = true", "cmd ="},
			"diffview.lua": {"lazy = true", "cmd ="},
		}

		pluginPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "dev")

		for file, patterns := range devPlugins {
			path := filepath.Join(pluginPath, file)
			content, err := os.ReadFile(path)
			if err != nil {
				t.Errorf("Failed to read %s: %v", file, err)
				continue
			}

			for _, pattern := range patterns {
				if !strings.Contains(string(content), pattern) {
					t.Errorf("%s should contain '%s' for lazy loading", file, pattern)
				}
			}
		}
	})
}

// TestNvimCompletionEngine verifies that blink.cmp is the only completion engine
func TestNvimCompletionEngine(t *testing.T) {
	t.Run("No nvim-cmp references", func(t *testing.T) {
		// Patterns that indicate nvim-cmp usage
		cmpPatterns := []string{
			"hrsh7th/nvim-cmp",
			"require.*[\"']cmp[\"']",
			"require[(][\"']cmp[\"']",
		}

		pluginPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins")

		err := filepath.Walk(pluginPath, func(path string, _ os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if strings.HasSuffix(path, ".lua") {
				content, err := os.ReadFile(path)
				if err != nil {
					return err
				}

				for _, pattern := range cmpPatterns {
					if matched, _ := regexp.MatchString(pattern, string(content)); matched {
						// Allow cmp references only in specific contexts
						if !(strings.Contains(path, "catppuccin.lua") && strings.Contains(string(content), "cmp = false")) { //nolint:staticcheck
							t.Errorf("Found nvim-cmp reference in %s", path)
						}
					}
				}
			}
			return nil
		})

		if err != nil {
			t.Errorf("Error walking plugin directory: %v", err)
		}
	})

	t.Run("Blink.cmp configuration", func(t *testing.T) {
		blinkPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "lsp", "blink.lua")
		content, err := os.ReadFile(blinkPath)
		if err != nil {
			t.Fatalf("Failed to read blink.lua: %v", err)
		}

		// Check for essential blink.cmp configurations
		requiredPatterns := []string{
			"saghen/blink.cmp",
			"lazy = false", // Blink should load immediately
		}

		for _, pattern := range requiredPatterns {
			if !strings.Contains(string(content), pattern) {
				t.Errorf("blink.lua should contain '%s'", pattern)
			}
		}
	})
}

// TestNvimMasonOptimization verifies that Mason only installs necessary tools
func TestNvimMasonOptimization(t *testing.T) {
	masonPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "lsp", "mason.lua")
	content, err := os.ReadFile(masonPath)
	if err != nil {
		t.Fatalf("Failed to read mason.lua: %v", err)
	}

	// Count the number of tools in ensure_installed
	lines := strings.Split(string(content), "\n")
	toolCount := 0
	inEnsureInstalled := false

	for _, line := range lines {
		if strings.Contains(line, "ensure_installed = {") {
			inEnsureInstalled = true
			continue
		}
		if inEnsureInstalled && strings.Contains(line, "}") {
			break
		}
		if inEnsureInstalled && strings.TrimSpace(line) != "" && strings.Contains(line, "\"") {
			toolCount++
		}
	}

	// Ensure we have a reasonable number of tools (not the original 76)
	if toolCount > 30 {
		t.Errorf("Mason has too many tools (%d). Should be optimized for TypeScript, Ruby, and Markdown", toolCount)
	}

	// Check for essential tools
	essentialTools := []string{
		"typescript-language-server",
		"ruby-lsp",
		"marksman",
	}

	for _, tool := range essentialTools {
		if !strings.Contains(string(content), tool) {
			t.Errorf("Mason should include essential tool: %s", tool)
		}
	}
}

// TestNvimThemeConfiguration verifies theme settings are consolidated
func TestNvimThemeConfiguration(t *testing.T) {
	t.Run("No duplicate theme configurations", func(t *testing.T) {
		themePath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "theme")

		// Check that certain plugins are not duplicated
		pluginCounts := make(map[string]int)

		err := filepath.Walk(themePath, func(path string, _ os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if strings.HasSuffix(path, ".lua") {
				content, err := os.ReadFile(path)
				if err != nil {
					return err
				}

				// Check for plugin definitions
				plugins := []string{
					"akinsho/bufferline.nvim",
					"nvim-lualine/lualine.nvim",
					"catppuccin/nvim",
				}

				for _, plugin := range plugins {
					if strings.Contains(string(content), fmt.Sprintf("\"%s\"", plugin)) ||
						strings.Contains(string(content), fmt.Sprintf("'%s'", plugin)) {
						pluginCounts[plugin]++
					}
				}
			}
			return nil
		})

		if err != nil {
			t.Errorf("Error walking theme directory: %v", err)
		}

		// Check for duplicates
		for plugin, count := range pluginCounts {
			if count > 1 {
				t.Errorf("Plugin %s is defined %d times (should be 1)", plugin, count)
			}
		}
	})

	t.Run("Catppuccin integrations optimized", func(t *testing.T) {
		// Get the working directory and build the path dynamically
		wd, err := os.Getwd()
		if err != nil {
			t.Fatalf("Failed to get working directory: %v", err)
		}

		// Navigate to the repo root and then to the theme file
		repoRoot := filepath.Dir(filepath.Dir(wd)) // Go up from _tests_/unit to repo root
		catppuccinPath := filepath.Join(repoRoot, "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "theme", "catppuccin.lua")

		// First check if the file exists
		if _, err := os.Stat(catppuccinPath); os.IsNotExist(err) {
			// File might have been consolidated into theme.lua.tmpl
			catppuccinPath = filepath.Join(repoRoot, "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "theme", "theme.lua.tmpl")
		} else {
			// If catppuccin.lua exists but redirects, use theme.lua.tmpl instead
			content, _ := os.ReadFile(catppuccinPath)
			if strings.Contains(string(content), "moved to theme.lua") {
				catppuccinPath = filepath.Join(repoRoot, "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "theme", "theme.lua.tmpl")
			}
		}

		content, err := os.ReadFile(catppuccinPath)
		if err != nil {
			t.Fatalf("Failed to read catppuccin configuration: %v", err)
		}

		// Check that default_integrations is false for optimization
		if strings.Contains(string(content), "default_integrations = true") {
			t.Error("Catppuccin should have default_integrations = false for optimization")
		}

		// Check that unnecessary integrations are disabled
		disabledIntegrations := []string{
			"cmp = false",    // Should use blink_cmp
			"dap = false",    // Load when debugging
			"dap_ui = false", // Load when debugging
		}

		for _, integration := range disabledIntegrations {
			if !strings.Contains(string(content), integration) {
				t.Logf("Warning: Catppuccin should have '%s' for optimization", integration)
			}
		}
	})
}

// TestNvimStartupOptimizations verifies startup performance optimizations
func TestNvimStartupOptimizations(t *testing.T) {
	initPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "init.lua")
	content, err := os.ReadFile(initPath)
	if err != nil {
		t.Fatalf("Failed to read init.lua: %v", err)
	}

	// Check that MCP server socket is deferred
	if !strings.Contains(string(content), "vim.schedule") {
		t.Error("MCP server socket creation should be deferred with vim.schedule")
	}

	// Check that the server socket code is wrapped properly
	if strings.Contains(string(content), "vim.fn.serverstart(socket_path)") &&
		!strings.Contains(string(content), "vim.schedule(function()") {
		t.Error("Server socket creation should be inside vim.schedule callback")
	}
}

// TestNvimSnacksOptimization verifies Snacks.nvim is properly configured
func TestNvimSnacksOptimization(t *testing.T) {
	snacksPath := filepath.Join("..", "..", "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "utilities", "snacks.lua")
	content, err := os.ReadFile(snacksPath)
	if err != nil {
		t.Fatalf("Failed to read snacks.lua: %v", err)
	}

	// Check for proper indent configuration
	if !strings.Contains(string(content), "indent = {") || !strings.Contains(string(content), "enabled = true") {
		t.Error("Snacks indent module should be properly configured")
	}
}

// TestNvimPipelineIntegration verifies pipeline.nvim is safely integrated
func TestNvimPipelineIntegration(t *testing.T) {
	// Get the working directory and build the path dynamically
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("Failed to get working directory: %v", err)
	}

	// Navigate to the repo root and then to the theme file
	repoRoot := filepath.Dir(filepath.Dir(wd)) // Go up from _tests_/unit to repo root
	themePath := filepath.Join(repoRoot, "MISSION_CONTROL", "dot_config", "nvim", "lua", "plugins", "theme", "theme.lua.tmpl")

	content, err := os.ReadFile(themePath)
	if err != nil {
		t.Fatalf("Failed to read theme.lua: %v", err)
	}

	// Check for safe pipeline loading in lualine
	if strings.Contains(string(content), "\"pipeline\"") && !strings.Contains(string(content), "pcall") {
		t.Error("Pipeline component in lualine should use pcall for safe loading")
	}

	// Check that the pipeline component has a condition check
	if strings.Contains(string(content), "pipeline") && !strings.Contains(string(content), "cond = function()") {
		t.Error("Pipeline component should have a condition function to check if loaded")
	}
}
