#!/opt/homebrew/bin/nu

source ~/.config/nushell/env.nu

if ($env | get --optional TMUX | is-empty ) {
  exec "/opt/homebrew/bin/tmux" new-session -A -s "ghostty"
} else {
  /opt/homebrew/bin/nu
}
