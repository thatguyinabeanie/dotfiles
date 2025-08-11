#!/bin/bash

window_state() {
  source "$HOME/.config/sketchybar/colors.sh"
  source "$HOME/.config/sketchybar/icons.sh"

  # Check if there's a focused window in AeroSpace
  WINDOW_INFO=$(aerospace list-windows --focused --format '%{window-id} %{app-name} %{window-title}' 2>/dev/null)
  
  args=()
  if [ -n "$WINDOW_INFO" ]; then
    # Window exists - show basic tiling icon
    args+=(--set $NAME icon=$YABAI_GRID icon.color=$ORANGE label.drawing=off)
  else
    # No focused window
    args+=(--set $NAME icon=$YABAI_GRID icon.color=$GREY label.drawing=off)
  fi

  sketchybar -m "${args[@]}"
}

windows_on_spaces () {
  # Get all workspaces on focused monitor
  CURRENT_SPACES=$(aerospace list-workspaces --monitor focused --format '%{workspace}' 2>/dev/null)

  args=()
  while IFS= read -r space; do
    if [ -n "$space" ]; then
      icon_strip=" "
      # Get apps in this workspace
      apps=$(aerospace list-windows --workspace "$space" --format '%{app-name}' 2>/dev/null)
      if [ -n "$apps" ]; then
        while IFS= read -r app; do
          if [ -n "$app" ]; then
            icon_strip+=" $($HOME/.config/sketchybar/plugins/icon_map.sh "$app")"
          fi
        done <<< "$apps"
      fi
      args+=(--set space.$space label="$icon_strip" label.drawing=on)
    fi
  done <<< "$CURRENT_SPACES"

  sketchybar -m "${args[@]}"
}

mouse_clicked() {
  # Toggle between floating and tiling layout
  aerospace layout floating tiling
  window_state
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "forced") exit 0
  ;;
  "window_focus") window_state 
  ;;
  "windows_on_spaces") windows_on_spaces
  ;;
esac