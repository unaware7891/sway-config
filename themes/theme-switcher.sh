#!/usr/bin/env bash
set -euo pipefail

THEMES_DIR="$HOME/.config/themes"
HELLWAL_DIR="$HOME/.config/hellwal/themes"
CURRENT_WALL="$THEMES_DIR/current/wallpaper.png"
CACHE_DIR="$HOME/.cache/hellwal"
LAST_THEME_FILE="$CACHE_DIR/last-theme"

mkdir -p "$CACHE_DIR"

############################
# Helpers
############################

list_themes() {
  for hw in "$HELLWAL_DIR"/*.hellwal; do
    local name
    name=$(basename "$hw" .hellwal)

    if [ -f "$THEMES_DIR/$name/wallpaper.png" ]; then
      echo "$name"
    fi
  done
}

apply_hellwal() {
  hellwal -t "$HELLWAL_DIR/$1.hellwal"
}

apply_wallpaper() {
  ln -sf "$THEMES_DIR/$1/wallpaper.png" "$CURRENT_WALL"
}

reload_services() {
  swaymsg reload >/dev/null

  # waybar
  pkill -USR2 waybar 2>/dev/null || true

  # mako (reload safely)
  if pgrep -x mako >/dev/null; then
    pkill mako
  fi
  mako &
  disown
}

notify_theme() {
  notify-send \
    "Theme applied" \
    "$1" \
    -u low
}

############################
# Main
############################

theme=$(list_themes | wofi --dmenu --prompt "Theme")
[ -z "$theme" ] && exit 0

# skip if same theme
if [ -f "$LAST_THEME_FILE" ] && grep -qx "$theme" "$LAST_THEME_FILE"; then
  exit 0
fi

apply_hellwal "$theme"
apply_wallpaper "$theme"

echo "$theme" >"$LAST_THEME_FILE"

reload_services
notify_theme "$theme"
