package tests

import (
	"fmt"
	"runtime"
	"strings"
	"testing"
)

// ANSI color codes
const (
	colorReset   = "\033[0m"
	colorRed     = "\033[31m"
	colorGreen   = "\033[32m"
	colorYellow  = "\033[33m"
	colorBlue    = "\033[34m"
	colorPurple  = "\033[35m"
	colorCyan    = "\033[36m"
	colorWhite   = "\033[37m"
	colorBold    = "\033[1m"
	colorBgGreen = "\033[42m"
	colorBgBlue  = "\033[44m"
)

// TestResult represents the result of a test
type TestResult struct {
	Name      string
	Passed    bool
	Message   string
	FileName  string
	LineNum   int
	SkipColor bool
}

// PrintTestHeader prints a visually appealing header for a test
func PrintTestHeader(t *testing.T, description string) {
	if runtime.GOOS == "windows" {
		// Windows terminal might not support ANSI colors
		t.Logf("\n=== %s ===\n", description)
		return
	}

	header := fmt.Sprintf("%s%s=== %s ===%s", colorBold, colorBlue, description, colorReset)
	separator := strings.Repeat("=", len(description)+8)

	t.Logf("\n%s%s%s%s\n%s\n%s%s%s%s\n",
		colorBold, colorBlue, separator, colorReset,
		header,
		colorBold, colorBlue, separator, colorReset)
}

// PrintTestResult prints a visually appealing result for a test
func PrintTestResult(t *testing.T, result TestResult) {
	if runtime.GOOS == "windows" || result.SkipColor {
		// Windows terminal might not support ANSI colors
		status := "PASSED"
		if !result.Passed {
			status = "FAILED"
		}
		t.Logf("[%s] %s: %s", status, result.Name, result.Message)
		return
	}

	var statusColor, statusText string
	if result.Passed {
		statusColor = colorGreen
		statusText = "✓ PASSED"
	} else {
		statusColor = colorRed
		statusText = "✗ FAILED"
	}

	location := ""
	if result.FileName != "" && result.LineNum > 0 {
		location = fmt.Sprintf(" (%s:%d)", result.FileName, result.LineNum)
	}

	t.Logf("%s%s[%s]%s %s%s%s: %s%s",
		colorBold, statusColor, statusText, colorReset,
		colorBold, result.Name, colorReset,
		result.Message, location)
}

// PrintTestSummary prints a visually appealing summary of all tests
func PrintTestSummary(t *testing.T, results []TestResult) {
	if len(results) == 0 {
		return
	}

	passed := 0
	for _, result := range results {
		if result.Passed {
			passed++
		}
	}

	if runtime.GOOS == "windows" {
		// Windows terminal might not support ANSI colors
		t.Logf("\n=== TEST SUMMARY ===")
		t.Logf("Total: %d, Passed: %d, Failed: %d", len(results), passed, len(results)-passed)
		return
	}

	t.Logf("\n%s%s=== TEST SUMMARY ===%s", colorBold, colorPurple, colorReset)

	statusColor := colorGreen
	if passed < len(results) {
		statusColor = colorRed
	}

	t.Logf("%sTotal:%s %d  %s%sPassed:%s %d  %s%sFailed:%s %d",
		colorBold, colorReset, len(results),
		colorBold, colorGreen, colorReset, passed,
		colorBold, colorRed, colorReset, len(results)-passed)

	if passed == len(results) {
		t.Logf("\n%s%s%s ALL TESTS PASSED! %s%s%s\n",
			colorBold, statusColor, strings.Repeat("★", 3),
			strings.Repeat("★", 3), colorReset, colorReset)
	}
}
