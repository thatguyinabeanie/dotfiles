#!/bin/bash

# Get the list of changed files from git
CHANGED_FILES=$(git diff --name-only HEAD)

# Initialize an array to store test files to run
TEST_FILES=()

# Function to find corresponding test file for a given source file
find_test_file() {
    local source_file=$1
    local test_file
    
    # Remove leading path components and get the base name
    local base_name=$(basename "$source_file")
    
    # Try to find corresponding test file
    test_file=$(find __tests__ -name "*_test.go" -type f -exec grep -l "$base_name" {} \;)
    
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
    # Remove duplicates and run specific tests
    UNIQUE_TEST_FILES=($(printf "%s\n" "${TEST_FILES[@]}" | sort -u))
    echo "Running tests for changed files..."
    for test_file in "${UNIQUE_TEST_FILES[@]}"; do
        echo "Running tests in $test_file"
        go test -v "$test_file"
    done
fi 