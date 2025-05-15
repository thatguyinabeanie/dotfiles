#!/bin/bash

# Cache file for test mappings
CACHE_FILE=".test_mapping_cache"
CACHE_DIR=".cache"
mkdir -p "$CACHE_DIR"

# Get the list of changed files from git
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Initialize an array to store test files to run
TEST_FILES=()

# Function to build or update the cache
build_cache() {
    echo "Building test mapping cache..."
    rm -f "$CACHE_DIR/$CACHE_FILE"
    find . -name "*.go" -not -path "*/__tests__/*" | while read -r source_file; do
        base_name=$(basename "$source_file")
        test_file=$(find __tests__ -name "*_test.go" -type f -exec grep -l "$base_name" {} \;)
        if [ -n "$test_file" ]; then
            echo "$source_file:$test_file" >> "$CACHE_DIR/$CACHE_FILE"
        fi
    done
}

# Function to find corresponding test file using cache
find_test_file() {
    local source_file=$1
    local test_file
    
    # Check if cache exists and is not older than 1 hour
    if [ ! -f "$CACHE_DIR/$CACHE_FILE" ] || [ $(($(date +%s) - $(stat -f %m "$CACHE_DIR/$CACHE_FILE"))) -gt 3600 ]; then
        build_cache
    fi
    
    # Look up in cache
    test_file=$(grep "^$source_file:" "$CACHE_DIR/$CACHE_FILE" | cut -d: -f2)
    
    if [ -n "$test_file" ]; then
        echo "$test_file"
    fi
}

# Process each changed file
for file in $CHANGED_FILES; do
    # Skip non-Go files
    if [[ ! "$file" =~ \.go$ ]]; then
        continue
    fi
    
    # Find corresponding test file
    test_file=$(find_test_file "$file")
    
    if [ -n "$test_file" ]; then
        TEST_FILES+=("$test_file")
    fi
done

# If no specific test files were found, run all tests
if [ ${#TEST_FILES[@]} -eq 0 ]; then
    echo "No specific test files found. Running all tests..."
    go test -v ./...
else
    # Remove duplicates and run specific tests in parallel
    UNIQUE_TEST_FILES=($(printf "%s\n" "${TEST_FILES[@]}" | sort -u))
    echo "Running tests for changed files..."
    
    # Create a temporary file for test results
    TEMP_RESULTS=$(mktemp)
    
    # Run tests in parallel with a limit of 4 concurrent tests
    for test_file in "${UNIQUE_TEST_FILES[@]}"; do
        echo "Running tests in $test_file"
        go test -v "$test_file" >> "$TEMP_RESULTS" 2>&1 &
        
        # Limit concurrent tests
        if [[ $(jobs -r -p | wc -l) -ge 4 ]]; then
            wait -n
        fi
    done
    
    # Wait for all tests to complete
    wait
    
    # Display results
    cat "$TEMP_RESULTS"
    rm "$TEMP_RESULTS"
    
    # Check if any tests failed
    if grep -q "FAIL" "$TEMP_RESULTS"; then
        exit 1
    fi
fi 