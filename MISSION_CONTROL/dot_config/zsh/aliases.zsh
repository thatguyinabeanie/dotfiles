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

# --- AI Command Helper (requires OPENAI_API_KEY env var) ---
ai() {
  prompt="You are a shell expert. Given the following request, output the best shell command only. Request: $*"
  curl -s https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": '"$prompt"'}]}' \
    | jq -r '.choices[0].message.content'
}

# --- Animated Terminal Clear ---
function clear() {
  for i in {1..10}; do
    echo
    sleep 0.02
done
  command clear
}
