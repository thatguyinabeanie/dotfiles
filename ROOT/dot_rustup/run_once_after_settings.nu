#!/usr/bin/env nu

# Check if Rust is already installed via mise
let rustc_path = (try { which rustc } catch { "" })
let mise_rust = if ($rustc_path | is-empty) {
  false
} else {
  $rustc_path | str contains "mise" | any { |it| $it }
}

if $mise_rust {
  echo "🟠 Rust is already managed by mise, skipping rustup installation..."
  echo "🔵 Using mise-managed Rust toolchain."
} else {
  echo "🟠 Installing/Updating Rust toolchain via rustup..."
  rustup-init --quiet --default-toolchain nightly --profile default -y --no-modify-path | save --append /dev/null
  echo "🔵 Rust toolchain installed/updated via rustup."
}

echo "🟠 Installing pokeget-rs cargo package..."
cargo install --quiet pokeget
echo "🔵 pokeget-rs installed."

