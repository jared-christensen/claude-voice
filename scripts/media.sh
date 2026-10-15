#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: media.sh pause|resume
# Pauses Apple Music and Spotify if they are playing (and remembers which), or resumes the ones we paused.
state="${TMPDIR:-/tmp}/spoken-replies-paused"
case "$1" in
  pause)
    : > "$state"
    for app in Music Spotify; do
      pgrep -xq "$app" || continue   # only touch apps that are already running
      if [ "$(osascript -e "tell application \"$app\" to player state as string" 2>/dev/null)" = playing ]; then
        osascript -e "tell application \"$app\" to pause" >/dev/null 2>&1 && echo "$app" >> "$state"
      fi
    done ;;
  resume)
    [ -s "$state" ] || exit 0
    while read -r app; do osascript -e "tell application \"$app\" to play" >/dev/null 2>&1; done < "$state"
    rm -f "$state" ;;
esac
exit 0
