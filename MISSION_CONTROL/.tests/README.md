# Dotfiles Tests

This directory contains tests for the dotfiles repository structure and configuration.

## Running Tests

To run the tests, navigate to this directory and run:

```bash
go test -v
```

The `-v` flag enables verbose output with colorful test results.

## Test Structure

The tests verify the following aspects of the dotfiles repository:

1. **Config Directory Structure** - Ensures that all required configuration directories exist
2. **Obsidian Directory Structure** - Verifies the Obsidian configuration and directory structure
3. **Source Directory Structure** - Checks the source directory and external repository configuration

## Test Output

The tests use colorful output to make it easy to see what's being tested and whether tests pass or fail:

```
==================================
=== CONFIG DIRECTORY STRUCTURE ===
==================================
[✓ PASSED] Config Dir: nvim: Directory at /path/to/dot_config/nvim
[✓ PASSED] Config Dir: nushell: Directory at /path/to/dot_config/nushell
...

=== TEST SUMMARY ===
Total: 6  Passed: 6  Failed: 0

★★★ ALL TESTS PASSED! ★★★
```

## Adding New Tests

To add a new test:

1. Create a new test function in `main_test.go`
2. Use the test utilities from `test_utils.go` for consistent output
3. Follow the pattern of existing tests:
   - Use `PrintTestHeader()` to create a section header
   - Create a `results` slice to track test results
   - Use `PrintTestResult()` for each individual check
   - Use `PrintTestSummary()` at the end of the test

Example:

```go
func TestNewFeature(t *testing.T) {
    PrintTestHeader(t, "NEW FEATURE")
    
    results := []TestResult{}
    
    // Your test logic here
    result := TestResult{
        Name:    "Feature Check",
        Passed:  true,
        Message: "Feature is working correctly",
    }
    PrintTestResult(t, result)
    results = append(results, result)
    
    PrintTestSummary(t, results)
}
```
