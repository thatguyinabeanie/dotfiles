# Testing Infrastructure

Comprehensive guide to the testing system for the dotfiles repository.

## 🏗️ Testing Architecture

```text
Testing Infrastructure:
├── Unit Tests (.tests/unit/)
│   ├── config_test.go           # Configuration validation
│   ├── nvim_config_test.go      # Neovim setup testing  
│   └── tmux_config_test.go      # Tmux configuration testing
├── Integration Tests (.tests/integration/)
│   └── fs_test.go              # File system operations
├── GitHub Actions (.github/workflows/)
│   ├── lint.yml                # Code quality checks
│   └── security.yml            # Security scanning
├── Helpers (.tests/helpers/)
│   └── testutils.go            # Shared test utilities
└── Scripts (.tests/scripts/)
    └── run_relevant_tests.sh   # Smart test execution
```

## 🧪 Test Types & Coverage

### Unit Tests

**Location**: `.tests/unit/`  
**Purpose**: Test individual components and configurations

#### Configuration Tests (`config_test.go`)

```go
// Tests chezmoi configuration validity
func TestChezmoiConfig(t *testing.T) {
    // Validates template processing
    // Checks environment variable handling
    // Verifies configuration completeness
}

// Tests data structure integrity
func TestDataStructure(t *testing.T) {
    // Validates YAML structure in .chezmoidata/
    // Checks for required fields
    // Verifies cross-references
}
```

#### Neovim Tests (`nvim_config_test.go`)

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

#### Tmux Tests (`tmux_config_test.go`)

```go
// Tests tmux configuration validity
func TestTmuxConfig(t *testing.T) {
    // Validates tmux.conf syntax
    // Checks plugin configurations
    // Verifies keybinding definitions
}
```

### Integration Tests

**Location**: `.tests/integration/`  
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

### Test Utilities

#### Shared Helpers (`helpers/testutils.go`)

```go
// Common test utilities and setup functions
func SetupTestEnvironment() TestEnv {
    // Creates isolated test environment
    // Sets up temporary directories
    // Configures test data
}

func CleanupTestEnvironment(env TestEnv) {
    // Removes test artifacts
    // Restores original state
    // Cleans up temporary files
}
```

## 🚀 CI/CD Workflows

### Lint Workflow (`.github/workflows/lint.yml`)

**Triggers**: Push to main, pull requests  
**Purpose**: Code quality and style validation

```yaml
name: Lint
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linting checks
        run: |
          # Shell script linting
          shellcheck **/*.sh
          
          # YAML validation  
          yamllint .chezmoidata/
          
          # Lua formatting check
          stylua --check .
```

### Security Workflow (`.github/workflows/security.yml`)

**Purpose**: Security scanning and vulnerability detection

```yaml
name: Security
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run security scans
        run: |
          # Secret detection
          gitleaks detect --source . --verbose
          
          # Additional security checks
          # Dependency scanning
          # Configuration validation
```

## 🎯 Local Development

### Running Tests Locally

```bash
# Run all tests
cd .tests
go test -v ./...

# Run specific test suite
go test -v ./unit/
go test -v ./integration/

# Run with coverage
go test -v ./... -coverprofile=coverage.out
go tool cover -html=coverage.out  # View coverage report

# Run single test file
go test -v ./unit/config_test.go
```

### Test Development Guidelines

```go
// Test naming convention
func TestFeatureName(t *testing.T) {
    // Setup
    setup := helpers.SetupTestEnvironment()
    defer helpers.CleanupTestEnvironment(setup)

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

## 🔧 Smart Test Execution

### Relevant Tests Runner (`scripts/run_relevant_tests.sh`)

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

if echo "$CHANGED_FILES" | grep -q "tmux"; then
    echo "🧪 Running Tmux tests..."
    go test -v ./unit/tmux_config_test.go
fi

if echo "$CHANGED_FILES" | grep -q "chezmoi\|yaml"; then
    echo "🧪 Running configuration tests..."
    go test -v ./unit/config_test.go
fi

# Always run integration tests for significant changes
if [ $(echo "$CHANGED_FILES" | wc -l) -gt 5 ]; then
    echo "🧪 Running integration tests..."
    go test -v ./integration/
fi
```

**Features**:
- **Change detection** via git diff analysis
- **Selective execution** based on modified components  
- **Performance optimization** (faster local testing)
- **Intelligent fallbacks** for comprehensive coverage

### Neovim-Specific Testing (`run_nvim_tests.sh`)

**Purpose**: Validate Neovim configuration in isolation

```bash
#!/bin/bash
# Neovim-specific testing and validation

# Test Neovim startup
echo "Testing Neovim startup..."
timeout 30s nvim --headless -c "lua print('Startup test')" -c "qa"
if [ $? -eq 124 ]; then
    echo "❌ Neovim startup timeout - configuration issue detected"
    exit 1
fi

# Plugin health checks
echo "Running plugin health checks..."
nvim --headless -c "checkhealth" -c "qa" > health_report.txt
if grep -q "ERROR" health_report.txt; then
    echo "❌ Plugin health issues detected"
    cat health_report.txt
    exit 1
fi

echo "✅ Neovim tests passed"
```

## 📊 Coverage & Quality Metrics

### Current Test Structure

The testing infrastructure includes:

1. **Unit Tests**: 3 test files covering core components
2. **Integration Tests**: 1 test file for end-to-end scenarios  
3. **Helper Utilities**: Shared test functions and setup
4. **CI/CD Integration**: Automated linting and security checks

### Quality Gates

1. **Lint checks**: shellcheck, yamllint, stylua
2. **Security scanning**: gitleaks for secret detection
3. **Configuration validation**: chezmoi template syntax
4. **Neovim health**: Plugin and configuration validation

### Local Quality Checks

```bash
# Run all quality checks locally
lefthook run pre-commit

# Individual checks
shellcheck **/*.sh                    # Shell script linting
yamllint .chezmoidata/               # YAML validation  
stylua --check .                     # Lua formatting
gitleaks detect --source .           # Secret detection
```

## 🚨 Troubleshooting

### Common Test Failures

#### Template Rendering Errors

```bash
# Debug template issues
chezmoi execute-template < problematic_template.tmpl
chezmoi data  # Check available template data
chezmoi verify  # Validate all templates
```

#### Neovim Plugin Conflicts

```bash
# Check plugin health
nvim --headless -c "checkhealth" -c "qa"

# Test minimal configuration
nvim -u NONE  # Start without plugins

# Debug specific plugin
nvim --headless -c "Lazy health" -c "qa"
```

#### Go Module Issues

```bash
# Update dependencies
cd .tests
go mod tidy
go mod download

# Clear module cache if needed
go clean -modcache
```

### Performance Issues

```bash
# Profile test execution
go test -v ./... -cpuprofile=cpu.prof
go tool pprof cpu.prof

# Set timeout limits
go test -v ./... -timeout=30s

# Run specific slow tests
go test -v -run=TestSpecificFunction
```

## 📈 Metrics & Monitoring

### Test Metrics Tracked

- **Execution time** (per test suite)
- **Test coverage** (where applicable)
- **Failure rate** (trending over time)
- **Configuration validation** (template syntax, YAML structure)

### GitHub Actions Insights

The workflows provide:
- **Automated quality checks** on every push/PR
- **Security scanning** for secrets and vulnerabilities
- **Multi-platform validation** (where applicable)
- **Consistent code formatting** enforcement

## 🔮 Future Enhancements

### Planned Improvements

1. **Coverage reporting** for Go tests with thresholds
2. **Integration testing** for external tool dependencies
3. **Performance benchmarking** with historical comparison
4. **Cross-platform testing** (Linux, macOS validation)
5. **Automated test generation** for new configurations

### Test Automation Opportunities

- **Auto-generated tests** for new Neovim plugins
- **Configuration validation rules** as code
- **Dependency testing** for external tools (mise, homebrew)
- **Template rendering validation** for all chezmoi templates

## 🎯 Best Practices

### Writing Effective Tests

1. **Focus on critical paths**: Test configuration loading, template rendering
2. **Use table-driven tests**: Handle multiple scenarios efficiently
3. **Isolate test environments**: Use temporary directories and cleanup
4. **Mock external dependencies**: Don't rely on network or system state
5. **Validate error conditions**: Test failure scenarios and edge cases

### Maintenance Guidelines

1. **Keep tests fast**: Use selective execution for development
2. **Update tests with changes**: Modify tests when configuration changes
3. **Document test purposes**: Clear test names and comments
4. **Regular test reviews**: Ensure tests remain relevant and valuable

This testing infrastructure provides confidence in the dotfiles configuration while maintaining development velocity through smart test execution and comprehensive quality checks.