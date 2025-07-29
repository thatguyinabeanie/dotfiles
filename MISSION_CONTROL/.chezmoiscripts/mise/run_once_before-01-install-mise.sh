#!/bin/bash

# Install mise if not already installed
if ! command -v mise >/dev/null 2>&1; then
	echo "🔧 Installing mise version manager..."

	# Create .local/bin directory if it doesn't exist
	mkdir -p "$HOME/.local/bin"

	# Check for curl or wget
	if command -v curl >/dev/null 2>&1; then
		echo "📥 Downloading mise installer via curl..."
		if curl -fsSL https://mise.jdx.dev/install.sh | sh; then
			echo "✅ mise download and installation completed"
		else
			echo "❌ Failed to install mise via curl"
			exit 1
		fi
	elif command -v wget >/dev/null 2>&1; then
		echo "📥 Downloading mise installer via wget..."
		if wget -qO- https://mise.jdx.dev/install.sh | sh; then
			echo "✅ mise download and installation completed"
		else
			echo "❌ Failed to install mise via wget"
			exit 1
		fi
	else
		echo "❌ Neither curl nor wget is installed. Cannot install mise."
		echo "👉 To install curl or wget, try the following commands based on your system:"
		echo "   - Debian/Ubuntu: sudo apt update && sudo apt install curl wget"
		echo "   - RHEL/CentOS: sudo yum install curl wget"
		echo "   - macOS: brew install curl wget"
		echo "For more information, visit:"
		echo "   - curl: https://curl.se/docs/install.html"
		echo "   - wget: https://www.gnu.org/software/wget/"
		exit 1
	fi

	# Add mise to PATH for the current session
	export PATH="$HOME/.local/bin:$PATH"

	# Verify installation
	if command -v mise >/dev/null 2>&1; then
		echo "🔵 mise $(mise --version) installed successfully"
	else
		echo "❌ mise installation failed - command not found after installation"
		exit 1
	fi
else
	echo "🔵 mise $(mise --version) already installed"
fi
