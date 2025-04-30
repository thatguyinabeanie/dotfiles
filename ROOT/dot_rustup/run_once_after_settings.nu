#!/usr/bin/env nu

echo "🟠 Installing/Updating Rust toolchain..."
rustup-init --quiet --default-toolchain nightly --profile default -y --no-modify-path | save --append /dev/null
echo "🔵 Rust toolchain installed/updated."

echo "🟠 Installing pokeget-rs cargo package..."
cargo install --quiet pokeget
echo "🔵 pokeget-rs installed."

