#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: media.sh pause | claim <pid> | resume <pid>
# Pauses whatever is playing (browser, podcast, video) while Claude speaks, and resumes it afterward.
# Needs the optional `media-control` tool (brew install media-control); does nothing without it.
command -v media-control >/dev/null && command -v jq >/dev/null || exit 0
state="${TMPDIR:-/tmp}/spoken-replies-paused"   # present while we hold media paused; contains the owning speech pid
playing() { [ "$(media-control get 2>/dev/null | jq -r '.playing // false')" = true ]; }
case "$1" in
  pause)
    if [ -e "$state" ]; then echo 0 > "$state"        # a previous reply already paused it; keep it paused
    elif playing; then media-control pause; echo 0 > "$state"; fi ;;
  claim)  [ -e "$state" ] && echo "$2" > "$state" ;;
  resume)
    while kill -0 "$2" 2>/dev/null; do sleep 0.3; done
    [ "$(cat "$state" 2>/dev/null)" = "$2" ] || exit 0   # a newer reply owns the pause now
    rm -f "$state"
    playing || media-control play ;;                     # skip if you already resumed it yourself
esac
exit 0
