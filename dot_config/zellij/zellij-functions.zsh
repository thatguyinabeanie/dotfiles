#!/bin/zsh

# Zellij shell integration functions
# Provides tmux-like workflow with session management

# ===============================
# CORE ZELLIJ FUNCTIONS
# ===============================

# Smart zellij launcher (replaces tmux behavior)
zellij_smart_attach() {
  if [[ $# -eq 0 ]]; then
    # No arguments - launch session manager like SessionX
    "$HOME/.config/zellij/scripts/zellij-sessionx"
  elif [[ $# -eq 1 ]]; then
    local session_name="$1"
    # Check if session exists
    if zellij list-sessions 2>/dev/null | grep -q "^$session_name "; then
      echo "🔗 Attaching to existing session: $session_name"
      zellij attach "$session_name"
    else
      echo "✨ Creating new session: $session_name"
      zellij --session "$session_name"
    fi
  else
    echo "Usage: zellij_smart_attach [session-name]"
    return 1
  fi
}

# Zellij session switcher (like tmux switch-client)
zellij_switch() {
  local session
  session=$(zellij list-sessions 2>/dev/null | fzf \
    --height 40% \
    --layout reverse \
    --no-border \
    --prompt "🔄 Switch to session: " \
    --header "Select session to switch to" \
    --color 'bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' |
    awk '{print $1}')

  if [[ -n "$session" ]]; then
    echo "🔄 Switching to session: $session"
    zellij attach "$session"
  fi
}

# Kill session with confirmation (like tmux kill-session)
zellij_kill_safe() {
  if [[ $# -eq 0 ]]; then
    local session
    session=$(zellij list-sessions 2>/dev/null | fzf \
      --height 40% \
      --layout reverse \
      --no-border \
      --prompt "💀 Kill session: " \
      --header "⚠️  Select session to kill (this will terminate it!)" \
      --color 'bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#94e2d5,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' |
      awk '{print $1}')

    if [[ -n "$session" ]]; then
      echo -n "❓ Really kill session '$session'? (y/N): "
      read -r confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        zellij kill-session "$session"
        echo "💀 Session '$session' killed"
      else
        echo "👍 Session '$session' preserved"
      fi
    fi
  else
    local session_name="$1"
    echo -n "❓ Really kill session '$session_name'? (y/N): "
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      zellij kill-session "$session_name"
      echo "💀 Session '$session_name' killed"
    else
      echo "👍 Session '$session_name' preserved"
    fi
  fi
}

# ===============================
# CHEZMOI INTEGRATION
# ===============================

# Quick chezmoi session (like your tmux Ctrl+d)
zellij_chezmoi() {
  local session_name="chezmoi"

  if zellij list-sessions 2>/dev/null | grep -q "^$session_name "; then
    echo "🔗 Attaching to existing chezmoi session"
    zellij attach "$session_name"
  else
    echo "✨ Creating new chezmoi session"
    cd ~/.local/share/chezmoi
    zellij --session "$session_name" --layout chezmoi
  fi
}

# Quick chezmoi with nvim (like your tmux Ctrl+e)
zellij_chezmoi_edit() {
  local session_name="chezmoi-edit"

  if zellij list-sessions 2>/dev/null | grep -q "^$session_name "; then
    echo "🔗 Attaching to existing chezmoi editing session"
    zellij attach "$session_name"
  else
    echo "✨ Creating new chezmoi editing session with nvim"
    cd ~/.local/share/chezmoi
    zellij --session "$session_name" --layout chezmoi-nvim
  fi
}

# ===============================
# TMUX COMPATIBILITY FUNCTIONS
# ===============================

# Recreate tmux muscle memory commands
tmux_new_session() {
  if [[ $# -eq 0 ]]; then
    echo "🚀 Creating new zellij session..."
    zellij
  else
    local session_name="$1"
    echo "🚀 Creating new zellij session: $session_name"
    zellij --session "$session_name"
  fi
}

tmux_attach() {
  if [[ $# -eq 0 ]]; then
    echo "📎 Use session manager to select session:"
    "$HOME/.config/zellij/scripts/zellij-sessionx"
  else
    local session_name="$1"
    echo "📎 Attaching to session: $session_name"
    zellij attach "$session_name"
  fi
}

tmux_list() {
  echo "📋 Active zellij sessions:"
  zellij list-sessions
}

tmux_kill() {
  if [[ $# -eq 0 ]]; then
    zellij_kill_safe
  else
    zellij_kill_safe "$1"
  fi
}

# ===============================
# AUTO-COMPLETION SETUP
# ===============================

# Zellij session name completion
_zellij_sessions() {
  local sessions
  sessions=($(zellij list-sessions 2>/dev/null | awk '{print $1}' | grep -v '^$'))
  _describe 'sessions' sessions
}

# Register completions if zsh completion system is available
if command -v compdef &>/dev/null; then
  compdef _zellij_sessions zellij_smart_attach
  compdef _zellij_sessions zellij_switch
  compdef _zellij_sessions zellij_kill_safe
  compdef _zellij_sessions tmux_attach
  compdef _zellij_sessions tmux_kill
fi

# ===============================
# ENVIRONMENT DETECTION
# ===============================

# Check if running inside zellij (like tmux detection)
if [[ -n "$ZELLIJ" ]]; then
  export ZELLIJ_SESSION=1

  # Auto-unlock zellij when vim exits (helps with vim navigation)
  vim_with_unlock() {
    command vim "$@"
    zellij action switch-mode normal 2>/dev/null || true
  }
  alias vim=vim_with_unlock
  alias nvim=vim_with_unlock
fi

# ===============================
# ALIASES FOR FUNCTIONS
# ===============================

# Main aliases
alias zx="zellij_smart_attach" # Smart attach/create
alias zw="zellij_switch"       # Switch sessions
alias zK="zellij_kill_safe"    # Safe kill with confirmation

# Chezmoi shortcuts
alias zcd="zellij_chezmoi"      # Chezmoi directory session
alias zce="zellij_chezmoi_edit" # Chezmoi editing session

# Tmux muscle memory
alias tn="tmux_new_session" # tmux new-session
alias ta="tmux_attach"      # tmux attach-session
alias tl="tmux_list"        # tmux list-sessions
alias tk="tmux_kill"        # tmux kill-session

# ===============================
# STARTUP MESSAGE
# ===============================

# Show helpful message on first load
zellij_welcome() {
  if [[ -z "$ZELLIJ_WELCOME_SHOWN" ]]; then
    export ZELLIJ_WELCOME_SHOWN=1
    echo ""
    echo "🧩 Zellij tmux-like setup loaded!"
    echo ""
    echo "Quick commands:"
    echo "  z     - Session manager (replaces SessionX)"
    echo "  zx    - Smart attach/create session"
    echo "  zw    - Switch between sessions"
    echo "  zcd   - Quick chezmoi session (Ctrl+d)"
    echo "  zce   - Quick chezmoi editing (Ctrl+e)"
    echo ""
    echo "Tmux compatibility:"
    echo "  ta/tn/tl/tk - tmux-like commands"
    echo ""
    echo "Key bindings:"
    echo "  Ctrl+a      - tmux prefix mode"
    echo "  Ctrl+o      - session manager"
    echo "  Ctrl+h/j/k/l - vim navigation"
    echo ""
  fi
}

# Show welcome message (comment out if you don't want it)
# zellij_welcome
