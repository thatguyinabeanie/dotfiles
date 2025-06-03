#!/bin/zsh

alias y="yazi"

alias ls="eza"
alias l="eza -l"
alias la="eza -la"

# --- Git Commit Emoji Selector (requires fzf) ---
function git_emoji_commit() {
  local emojis=(
    "✨ feat: A new feature"
    "🐛 fix: A bug fix"
    "📝 docs: Documentation only changes"
    "🎨 style: Code style changes"
    "🔥 remove: Remove code or files"
    "🚀 perf: Performance improvements"
    "✅ test: Adding tests"
    "🔧 chore: Maintenance"
    "🔀 merge: Merge branches"
    "⬆️ upgrade: Dependency upgrades"
  )
  local choice=$(printf '%s\n' "${emojis[@]}" | fzf)
  local emoji=$(echo $choice | awk '{print $1}')
  git commit -m "$emoji $*"
}

# --- Spotify Controller (macOS) ---
alias spotify_play='osascript -e "tell application \"Spotify\" to play"'
alias spotify_pause='osascript -e "tell application \"Spotify\" to pause"'
alias spotify_next='osascript -e "tell application \"Spotify\" to next track"'
alias spotify_prev='osascript -e "tell application \"Spotify\" to previous track"'
# alias claude="~/.claude/local/claude"

