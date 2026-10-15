#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# Stop: read Claude's last reply aloud (or just ding when voice is off or the mic is in use).
dir="$(dirname "$0")"
. "$dir/lib.sh"
ding() { nohup "$dir/ding.sh" done "$1" >/dev/null 2>&1 & }

[ -f "$VOICE_OFF_FLAG" ] && { ding 0; exit 0; }
[ ! -f "$MIC_IGNORE_FLAG" ] && [ "$("$dir/mic.sh")" = MIC_IN_USE ] && { ding 0; exit 0; }
msg=$(jq -r '.last_assistant_message // empty')
[ -n "$msg" ] || { ding 0; exit 0; }

text=$(printf '%s' "$msg" | MARKER="$MARKER" PAUSE_MS="$PAUSE_MS" perl -0pe '
  my $m = quotemeta($ENV{MARKER});
  s/\n[ \t]*$m.*//s;
  s/```.*?```/ code omitted /gs;
  s/\n\s*\n/ [[slnc $ENV{PAUSE_MS}]] /g;
  s/`//g;
  s/\[([^\]]*)\]\([^)]*\)/$1/g;
  s{https?://\S+}{link}g;
  s/[*#_>|]//g;
')

voice_args=()
installed=$(say -v '?')
IFS="|" read -ra wanted <<< "$VOICE"
for v in "${wanted[@]}"; do
  if grep -q "^$v " <<< "$installed"; then voice_args=(-v "$v"); break; fi
done

pkill -x say
ding "$DING_DELAY"
# Duck: lower the system volume so other audio fades back, and play the speech louder to make up for it.
speech_vol=$VOLUME; ducked=
if [ ! -f "$DUCK_OFF_FLAG" ] && "$dir/duck.sh" start "$DUCK_LEVEL"; then
  ducked=1
  speech_vol=$(awk -v v="$VOLUME" -v d="$DUCK_LEVEL" 'BEGIN { x = v / d; if (x > 1) x = 1; printf "%.2f", x }')
fi
nohup say "${voice_args[@]}" -r "$RATE" "[[volm $speech_vol]] $text" >/dev/null 2>&1 &
pid=$!
[ -n "$ducked" ] && nohup "$dir/duck.sh" restore-after "$pid" >/dev/null 2>&1 &
# stop speaking as soon as the mic opens
[ -f "$MIC_IGNORE_FLAG" ] || nohup "$dir/watch-mic.sh" "$pid" >/dev/null 2>&1 &
exit 0
