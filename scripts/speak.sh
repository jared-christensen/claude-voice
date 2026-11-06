#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: speak.sh <file-with-cleaned-text>
# Speaks the text: picks the voice, pauses your media, dings, and stops if your mic opens.
dir="$(dirname "$0")"
. "$dir/lib.sh"
text=$(cat "$1")

voice_args=()
installed=$(say -v '?')
IFS="|" read -ra wanted <<< "$VOICE"
for v in "${wanted[@]}"; do
  if grep -q "^$v " <<< "$installed"; then voice_args=(-v "$v"); break; fi
done

pkill -x say
[ -f "$MEDIA_OFF_FLAG" ] || "$dir/media.sh" pause
nohup "$dir/ding.sh" done "$DING_DELAY" >/dev/null 2>&1 &
nohup say "${voice_args[@]}" -r "$RATE" "[[volm $VOLUME]] $text" >/dev/null 2>&1 &
pid=$!
[ -f "$MEDIA_OFF_FLAG" ] || { "$dir/media.sh" claim "$pid"; nohup "$dir/media.sh" resume "$pid" >/dev/null 2>&1 & }
# stop speaking as soon as the mic opens
[ -f "$MIC_IGNORE_FLAG" ] || nohup "$dir/watch-mic.sh" "$pid" >/dev/null 2>&1 &
exit 0
