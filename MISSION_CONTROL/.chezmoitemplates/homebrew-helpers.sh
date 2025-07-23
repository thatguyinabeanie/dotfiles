#!/bin/bash
# Shared Homebrew Helper Functions
# shellcheck disable=SC1054,SC1083,SC1073,SC1072

setup_homebrew_path() {
{{ if eq .chezmoi.os "darwin" -}}
	if [ -f "/opt/homebrew/bin/brew" ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -f "/usr/local/bin/brew" ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
{{ else if eq .chezmoi.os "linux" -}}
	if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
{{ end -}}
}

install_packages() {
	local category="$1"
	local brewfile_content="$2"
	local emoji=""

	# Set emoji based on category
	case "$category" in
	taps) emoji="🔧" ;;
	brews) emoji="🍺" ;;
	casks) emoji="📦" ;;
	mas) emoji="🏪" ;;
	fonts) emoji="🔤" ;;
	shared) emoji="📦" ;;
	work) emoji="🏢" ;;
	personal) emoji="👤" ;;
	*) emoji="🍺" ;;
	esac

	if [ -n "$brewfile_content" ]; then
		echo "$emoji Installing $category..."
		echo "$brewfile_content" | brew bundle --file=- --quiet
		echo "🔵 $category installation complete"
	fi
}

check_brew() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "⚠️  Homebrew not installed. Skipping $1."
		exit 0
	fi
}
