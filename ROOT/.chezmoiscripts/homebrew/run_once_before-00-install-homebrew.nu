#!/opt/homebrew/bin/nu

print "🟠 Installing Homebrew Package Manager."
if (which brew | is-empty) {
  zsh -c $"(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | ignore
}
print "🔵 Homebrew Package Manager installed."
