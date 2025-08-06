#!/bin/bash

# Configuration
CACHE_DIR=".cache"
COVERAGE_DIR=".coverage"
HISTORY_DIR=".history"
SHARD_COUNT=4
COVERAGE_THRESHOLD=80
mkdir -p "$CACHE_DIR" "$COVERAGE_DIR" "$HISTORY_DIR"

# Get the list of changed files from git
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Initialize arrays
TEST_FILES=()
TEST_DURATIONS=()
FAILED_TESTS=()

# Function to process changed files
process_changed_files() {
    local file
    local test_file
    for file in $CHANGED_FILES; do
        if [[ "$file" =~ \.go$ ]]; then
            # Find corresponding test files
            test_file=""
            test_file=$(find . -name "*_test.go" -exec grep -l "$(basename "$file")" {} \;)
            if [ -n "$test_file" ]; then
                TEST_FILES+=("$test_file")
            fi
        fi
    done
}

# Function to get test dependencies
get_test_dependencies() {
    local test_file
    local deps_file
    test_file=$1
    deps_file="$CACHE_DIR/$(basename "$test_file").deps"
    
    if [ ! -f "$deps_file" ] || [ $(($(date +%s) - $(stat -f %m "$deps_file"))) -gt 3600 ]; then
        go list -f '{{.TestImports}}' "$test_file" > "$deps_file"
    fi
    cat "$deps_file"
}

# Function to update test history
update_test_history() {
    local test_file
    local history_file
    test_file=$1
    history_file="$HISTORY_DIR/$(basename "$test_file").history"
    
    # Get last 5 commits that modified this test
    git log --follow --pretty=format:"%h %ad %s" --date=short -5 -- "$test_file" >> "$history_file"
    echo "---" >> "$history_file"
}

# Function to categorize tests
categorize_test() {
    local test_file
    local categories
    test_file=$1
    categories=()
    
    # Check for test categories based on file location and content
    if [[ "$test_file" == *"/unit/"* ]]; then
        categories+=("unit")
    fi
    if [[ "$test_file" == *"/integration/"* ]]; then
        categories+=("integration")
    fi
    if grep -q "Benchmark" "$test_file"; then
        categories+=("benchmark")
    fi
    
    echo "${categories[@]}"
}

# Function to run test with caching
run_test_with_cache() {
    local test_file
    local cache_file
    local start_time
    local end_time
    local duration
    local source_file
    local categories
    local tags
    local coverage
    
    test_file=$1
    cache_file="$CACHE_DIR/$(basename "$test_file").result"
    start_time=$(date +%s.%N)
    
    # Check if we can use cached results
    if [ -f "$cache_file" ] && [ $(($(date +%s) - $(stat -f %m "$cache_file"))) -lt 3600 ]; then
        source_file=""
        source_file=$(grep "^$test_file:" "$CACHE_DIR/.test_mapping_cache" | cut -d: -f1)
        if [ -n "$source_file" ] && [ ! -f "$source_file" ] || [ "$(git diff --quiet "$source_file" 2>/dev/null)" ]; then
            echo "Using cached test results for $test_file"
            cat "$cache_file"
            return 0
        fi
    fi
    
    # Run the test with all features
    mapfile -t categories < <(categorize_test "$test_file")
    tags=$(IFS=,; echo "${categories[*]}")
    
    # Run test with coverage, benchmarks, and proper tags
    go test -v -coverprofile="$COVERAGE_DIR/$(basename "$test_file").coverage" \
           -bench=. -benchmem \
           -tags="$tags" \
           "$test_file" > "$cache_file" 2>&1
    
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc)
    TEST_DURATIONS+=("$test_file:$duration")
    
    # Update test history
    update_test_history "$test_file"
    
    # Check coverage
    coverage=""
    coverage=$(go tool cover -func="$COVERAGE_DIR/$(basename "$test_file").coverage" | grep total | awk '{print $3}' | sed 's/%//')
    if (( $(echo "$coverage < $COVERAGE_THRESHOLD" | bc -l) )); then
        echo "Warning: Test coverage for $test_file is below ${COVERAGE_THRESHOLD}% (current: ${coverage}%)"
        FAILED_TESTS+=("$test_file:coverage")
    fi
    
    # Check for test failures
    if grep -q "FAIL" "$cache_file"; then
        FAILED_TESTS+=("$test_file:fail")
    fi
    
    cat "$cache_file"
}

# Function to run tests in shards
run_tests_in_shards() {
    local test_files
    local total_tests
    local tests_per_shard
    local i
    local start
    local end
    local j
    
    test_files=("$@")
    total_tests=${#test_files[@]}
    tests_per_shard=$(( (total_tests + SHARD_COUNT - 1) / SHARD_COUNT ))
    
    for ((i=0; i<SHARD_COUNT; i++)); do
        start=$((i * tests_per_shard))
        end=$((start + tests_per_shard))
        if [ $start -lt "$total_tests" ]; then
            echo "Running shard $((i+1))/$SHARD_COUNT (tests $((start+1))-$((end > total_tests ? total_tests : end)))"
            for ((j=start; j<end && j<total_tests; j++)); do
                run_test_with_cache "${test_files[$j]}" &
            done
            wait
        fi
    done
}

# Main test execution
if [ ${#CHANGED_FILES[@]} -eq 0 ]; then
    echo "No files changed, running all tests..."
    # Find all test files
    mapfile -t TEST_FILES < <(find . -name "*_test.go")
else
    # Process changed files
    process_changed_files
fi

# Run tests in shards
if [ ${#TEST_FILES[@]} -gt 0 ]; then
    echo "Running ${#TEST_FILES[@]} tests in $SHARD_COUNT shards..."
    run_tests_in_shards "${TEST_FILES[@]}"
    
    # Report test durations
    echo -e "\nTest Durations:"
    printf "%s\n" "${TEST_DURATIONS[@]}" | sort -t: -k2 -n
    
    # Report failures
    if [ ${#FAILED_TESTS[@]} -gt 0 ]; then
        echo -e "\nFailed Tests:"
        printf "%s\n" "${FAILED_TESTS[@]}"
        exit 1
    fi
else
    echo "No tests to run"
fi

# Cleanup old files
find "$CACHE_DIR" -type f -mtime +1 -delete
find "$COVERAGE_DIR" -type f -mtime +1 -delete
find "$HISTORY_DIR" -type f -mtime +7 -delete 