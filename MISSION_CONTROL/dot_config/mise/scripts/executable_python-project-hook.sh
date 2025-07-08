#!/bin/bash
# Hook script to automatically install Python tools when entering Python projects
# This script is triggered by mise's environment hooks

set -euo pipefail

# Check if we're in a Python project (look for common Python files)
if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "Pipfile" ]] || [[ -f ".python-version" ]] || [[ -d "venv" ]] || [[ -d ".venv" ]]; then
	echo "🐍 Python project detected - ensuring Python tools are available..."

	# Run the main Python package installation task
	if command -v mise &>/dev/null; then
		mise run install-python-tools
	fi

	# Auto-create uv virtual environment if requirements files are found
	requirements_files=()
	for pattern in requirements*.txt requirements*.pip dev-requirements*.txt test-requirements*.txt; do
		if [[ -f "$pattern" ]]; then
			requirements_files+=("$pattern")
		fi
	done
	
	if [[ ${#requirements_files[@]} -gt 0 ]]; then
		if command -v uv >/dev/null 2>&1 && [ ! -d .venv ]; then
			echo "📦 Creating uv virtual environment for Python project..."
			uv venv
			if [ $? -eq 0 ]; then
				echo "✅ Virtual environment created successfully"
			fi
		fi
	fi
fi
