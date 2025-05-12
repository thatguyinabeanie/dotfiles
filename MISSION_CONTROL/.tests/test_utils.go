package tests

// TestResult represents the result of a test
type TestResult struct {
	Name      string
	Passed    bool
	Message   string
	FileName  string
	LineNum   int
	SkipColor bool
}
