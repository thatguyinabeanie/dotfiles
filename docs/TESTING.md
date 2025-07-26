# Testing infrastructure & CI/CD

Comprehensive guide to the testing system and continuous integration setup for the dotfiles repository.

## 🏗️ Testing architecture

```
Testing Infrastructure:
├── Unit Tests (_tests_/unit/)
│   ├── config_test.go           # Configuration validation
│   └── nvim_config_test.go      # Neovim setup testing
├── Integration Tests (_tests_/integration/)
│   ├── fs_test.go              # File system operations  
│   └── obsidian_test.go        # Obsidian integration
├── GitHub Actions (.github/workflows/)
│   ├── test.yml                # Main test suite
│   ├── test-nvim.yml           # Neovim-specific tests
│   ├── lint.yml                # Code quality checks
│   └── security.yml            # Security scanning
└── Scripts (_tests_/scripts/)
    ├── run_relevant_tests.sh   # Smart test execution
    └── test_nvim_startup.sh    # Neovim startup validation
```

## 🧪 Test types & coverage

### Unit tests
**Location**: `_tests_/unit/`
**Purpose**: test individual components and configurations

#### Configuration tests (`config_test.go`)
```go
// Tests chezmoi configuration validity
func TestChezmoiConfig(t *testing.T) {
    // Validates template processing
    // Checks environment variable handling
    // Verifies configuration completeness
}

// Tests mise integration
func TestMiseConfig(t *testing.T) {
    // Validates language version specifications
    // Checks dependency management setup
    // Verifies hook configurations
}
```

#### Neovim tests (`nvim_config_test.go`)
```go
// Tests plugin configuration integrity
func TestNeovimPlugins(t *testing.T) {
    // Validates plugin specifications
    // Checks for configuration conflicts
    // Verifies keybinding consistency
}

// Tests Lua configuration syntax
func TestLuaConfig(t *testing.T) {
    // Syntax validation for all .lua files
    // Dependency checking
    // Configuration completeness
}
```

### Integration Tests
**Location**: `_tests_/integration/`
**Purpose**: Test cross-component functionality and real-world scenarios

#### File System Tests (`fs_test.go`)
```go
// Tests file operations and permissions
func TestFileSystemOperations(t *testing.T) {
    // Validates file creation and symlinking
    // Tests permission handling
    // Verifies directory structure creation
}

// Tests chezmoi apply operations
func TestChezmoiApply(t *testing.T) {
    // End-to-end application testing
    // Template rendering validation
    // Configuration deployment verification
}
```

#### Obsidian Integration (`obsidian_test.go`)
```go
// Tests vault setup and configuration
func TestObsidianSetup(t *testing.T) {
    // Validates vault creation
    // Tests external repository cloning
    // Verifies configuration templating
}
```

## 🚀 CI/CD Workflows

### Main Test Suite (`.github/workflows/test.yml`)
**Triggers**: Push to main, pull requests
**Matrix Strategy**: Multiple OS and Go versions

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    go-version: [1.21, 1.22]

steps:
  - name: Run Tests
    run: |
      cd _tests_
      go test -v ./... -coverprofile=coverage.out
      
  - name: Coverage Check
    run: |
      coverage=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
      if (( $(echo "$coverage < 80" | bc -l) )); then
        echo "Coverage $coverage% is below threshold (80%)"
        exit 1
      fi
```

### Neovim-Specific Tests (`.github/workflows/test-nvim.yml`)
**Purpose**: Validate Neovim configuration in multiple environments
**Special Features**: Performance testing and startup time validation

```yaml
# Test Neovim startup performance
- name: Neovim Startup Test
  run: |
    timeout 30s nvim --headless -c "lua print('Startup test')" -c "qa"
    exit_code=$?
    if [ $exit_code -eq 124 ]; then
      echo "Neovim startup timeout - configuration issue detected"
      exit 1
    fi

# Plugin health checks
- name: Plugin Health Check
  run: |
    nvim --headless -c "checkhealth" -c "qa" > health_report.txt
    if grep -q "ERROR" health_report.txt; then
      echo "Plugin health issues detected"
      exit 1
    fi
```

## 🎯 Smart Test Execution

### Relevant Tests Runner (`run_relevant_tests.sh`)
**Purpose**: Run only tests affected by changes (performance optimization)

```bash
#!/bin/bash
# Intelligent test selection based on changed files

# Detect changed files
CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD)

# Determine relevant test suites
if echo "$CHANGED_FILES" | grep -q "nvim\|lua"; then
    echo "🧪 Running Neovim tests..."
    go test -v ./unit/nvim_config_test.go
fi

if echo "$CHANGED_FILES" | grep -q "mise\|python\|languages"; then
    echo "🧪 Running mise integration tests..."
    go test -v ./integration/mise_test.go
fi

# Always run core configuration tests
echo "🧪 Running core tests..."
go test -v ./unit/config_test.go
```

**Features**:
- **Change detection** via git diff analysis
- **Selective execution** based on modified components
- **Performance optimization** (faster CI runs)
- **Intelligent fallbacks** for comprehensive coverage

## 📊 Coverage & Quality Metrics

### Coverage Requirements
- **Minimum threshold**: 80% code coverage
- **Enforcement**: CI fails if coverage drops below threshold
- **Reporting**: Coverage reports generated for each PR

```bash
# Coverage calculation and enforcement
coverage=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
if (( $(echo "$coverage < 80" | bc -l) )); then
    echo "❌ Coverage $coverage% is below threshold (80%)"
    exit 1
else
    echo "✅ Coverage $coverage% meets threshold"
fi
```

### Quality Gates
1. **Lint checks** (golangci-lint)
2. **Security scanning** (gitleaks, gosec)
3. **Configuration validation** (yamllint, shellcheck)
4. **Template syntax** (chezmoi verify)

## 🔧 Local Development

### Running Tests Locally
```bash
# Run all tests
cd _tests_
go test -v ./...

# Run specific test suite
go test -v ./unit/
go test -v ./integration/

# Run with coverage
go test -v ./... -coverprofile=coverage.out
go tool cover -html=coverage.out  # View coverage report
```

### Test Development Guidelines
```go
// Test naming convention
func TestFeatureName(t *testing.T) {
    // Setup
    setup := createTestEnvironment()
    defer cleanup(setup)
    
    // Execute
    result := functionUnderTest(input)
    
    // Assert
    assert.Equal(t, expected, result)
    assert.NoError(t, err)
}

// Table-driven tests for multiple scenarios
func TestMultipleScenarios(t *testing.T) {
    tests := []struct {
        name     string
        input    string
        expected string
    }{
        {"basic_case", "input1", "output1"},
        {"edge_case", "input2", "output2"},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := processInput(tt.input)
            assert.Equal(t, tt.expected, result)
        })
    }
}
```

## 🚨 Troubleshooting

### Common Test Failures

#### Template Rendering Errors
```bash
# Debug template issues
chezmoi execute-template < problematic_template.tmpl
chezmoi data  # Check available template data
```

#### Neovim Plugin Conflicts
```bash
# Check plugin health
nvim --headless -c "checkhealth" -c "qa"

# Test minimal configuration
nvim -u NONE  # Start without plugins
```

#### Coverage Drops
```bash
# Identify uncovered code
go tool cover -func=coverage.out | grep -v "100.0%"

# Add tests for uncovered functions
# Focus on error paths and edge cases
```

### Performance Issues
```bash
# Profile test execution
go test -v ./... -cpuprofile=cpu.prof
go tool pprof cpu.prof

# Optimize slow tests
go test -v ./... -timeout=30s  # Set timeout limits
```

## 📈 Metrics & Monitoring

### Test Metrics Tracked
- **Execution time** (per test suite)
- **Coverage percentage** (per package)
- **Failure rate** (trending over time)
- **Startup performance** (Neovim initialization time)

### GitHub Actions Insights
```yaml
# Performance tracking in CI
- name: Track Performance
  run: |
    echo "Test execution time: $(date)" > performance.log
    time go test -v ./... >> performance.log
    
    # Upload metrics for trending analysis
    if [ "$GITHUB_EVENT_NAME" = "push" ]; then
      # Store metrics for performance tracking
      echo "Performance data stored"
    fi
```

## 🔮 Future Enhancements

### Planned Improvements
1. **Mutation testing** for better test quality validation
2. **Visual regression testing** for Neovim UI components
3. **Integration with external services** (API testing)
4. **Performance benchmarking** with historical comparison
5. **Automated test generation** for new configurations

### Test Automation
- **Auto-generated tests** for new Neovim plugins
- **Configuration validation rules** as code
- **Dependency testing** for external tools
- **Cross-platform compatibility** validation

This testing infrastructure ensures the reliability and quality of the dotfiles configuration across different environments and use cases, providing confidence in updates and changes.