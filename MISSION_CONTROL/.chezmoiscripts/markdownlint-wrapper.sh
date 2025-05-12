#!/bin/bash

# Capture outputs and errors
OUTPUT_FILE=$(mktemp)
ERRORS_FILE=$(mktemp)
FIXED_FILES=()
FAILED_FILES=()
CHANGES_MADE=false

# Find the markdownlint executable - try different possible locations
MARKDOWNLINT=""
for path in "$(npm bin)/markdownlint" "/usr/local/bin/markdownlint" "$(yarn bin)/markdownlint" "$(pnpm bin)/markdownlint"; do
  if [ -x "$path" ]; then
    MARKDOWNLINT="$path"
    break
  fi
done

# If not found in paths, try using npx
if [ -z "$MARKDOWNLINT" ]; then
  if command -v npx &> /dev/null; then
    MARKDOWNLINT="npx markdownlint"
  else
    echo "Error: markdownlint not found. Please install it with: npm install -g markdownlint-cli" >&2
    exit 1
  fi
fi

# Extract file arguments from the command line
FILES=()
ARGS=()
EXCLUDED_FILES=(".markdownlint.yaml" ".markdownlint.yml" ".markdownlint.json")

for arg in "$@"; do
  if [[ "$arg" == "--fix" ]]; then
    # Skip the --fix argument as we'll handle fixing manually
    continue
  elif [[ "$arg" == -* ]]; then
    # It's a flag or option
    ARGS+=("$arg")
  elif [[ -f "$arg" ]]; then
    # Check if it's a markdown file and not in the excluded list
    filename=$(basename "$arg")
    if [[ "$arg" == *.md ]] && ! [[ " ${EXCLUDED_FILES[@]} " =~ " $filename " ]]; then
      FILES+=("$arg")
    fi
  else
    # Other arguments
    ARGS+=("$arg")
  fi
done

# If no files were specified directly, find markdown files that changed
if [ ${#FILES[@]} -eq 0 ]; then
  # Get list of staged markdown files
  while IFS= read -r file; do
    filename=$(basename "$file")
    if [[ -f "$file" ]] && [[ "$file" == *.md ]] && ! [[ " ${EXCLUDED_FILES[@]} " =~ " $filename " ]]; then
      FILES+=("$file")
    fi
  done < <(git diff --cached --name-only)
fi

# Skip execution if no markdown files are found
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No markdown files to check."
  exit 0
fi

echo "🔍 Markdown linting and auto-fixing in progress..."

# Try to fix each file
for file in "${FILES[@]}"; do
  echo "  Checking $file..."

  # Check initial state before fixing
  $MARKDOWNLINT "${ARGS[@]}" "$file" > /dev/null 2>&1
  initial_status=$?

  # Skip auto-fixing if no issues found
  if [ $initial_status -eq 0 ]; then
    echo "    ✅ No issues found."
    FIXED_FILES+=("$file")
    continue
  fi

  # Try to auto-fix
  echo "    🔧 Attempting to auto-fix issues..."
  file_before_fix=$(mktemp)
  file_after_fix=$(mktemp)

  # Save file state before fixing
  cp "$file" "$file_before_fix"

  # Run auto-fix
  $MARKDOWNLINT --fix "${ARGS[@]}" "$file" > /dev/null 2>&1

  # Save file state after fixing
  cp "$file" "$file_after_fix"

  # Check if file was modified
  if ! cmp -s "$file_before_fix" "$file_after_fix"; then
    echo "    ⚙️ Auto-fix made changes to the file."
    CHANGES_MADE=true

    # Check if all issues were fixed
    $MARKDOWNLINT "${ARGS[@]}" "$file" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "    ✅ All issues fixed successfully!"
      FIXED_FILES+=("$file")
    else
      echo "    ⚠️ Some issues remain after auto-fixing."
      FAILED_FILES+=("$file")
    fi
  else
    echo "    ❌ Auto-fix failed to make any changes."
    FAILED_FILES+=("$file")
  fi

  # Clean up temp files
  rm -f "$file_before_fix" "$file_after_fix"
done

# Run the final check for pre-commit
$MARKDOWNLINT "${ARGS[@]}" "${FILES[@]}" > "$OUTPUT_FILE" 2> "$ERRORS_FILE"
exit_code=$?

# Display the original output first
cat "$OUTPUT_FILE"

# If there's an error, provide a more helpful message at the end
if [ $exit_code -ne 0 ]; then
  echo ""
  echo "┌─────────────────────────────────────────────────────────┐"
  echo "│ 🔍 MARKDOWN LINTING ERRORS SUMMARY                       │"
  echo "└─────────────────────────────────────────────────────────┘"
  echo ""

  # Show auto-fix attempt summary
  if [ ${#FIXED_FILES[@]} -gt 0 ]; then
    echo "✅ Files with no issues or auto-fixed successfully:"
    for file in "${FIXED_FILES[@]}"; do
      echo "  - $file"
    done
    echo ""
  fi

  echo "❌ Files with remaining issues:"
  for file in "${FAILED_FILES[@]}"; do
    echo "  - $file"
  done
  echo ""

  echo "Common fixes for the issues found:"
  echo "  • MD040 = Add a language to code blocks: \`\`\`bash (or \`\`\`yaml, \`\`\`json, etc.)"
  echo "  • MD032 = Add blank lines before and after lists"
  echo "  • MD013 = Break long lines into multiple lines"
  echo ""
  echo "These issues can be fixed by:"
  echo "1. Making the suggested changes manually, or"
  echo "2. Running: markdownlint --fix [filename]"
  echo ""

  if [ "$CHANGES_MADE" = true ]; then
    echo "Note: Auto-fixing DID make some changes, but some issues still require manual intervention."
  else
    echo "Note: Auto-fixing was attempted but FAILED to make any changes. All issues require manual intervention."
  fi
  echo ""
fi

# Clean up temp files
rm -f "$OUTPUT_FILE" "$ERRORS_FILE"

exit $exit_code
