#!/bin/bash
# Stop: read Claude's last reply aloud (or just ding when voice is off or the mic is in use).
dir="$(dirname "$0")"
. "$dir/lib.sh"
ding() { nohup "$dir/ding.sh" done "$1" >/dev/null 2>&1 & }

[ -f "$VOICE_FLAG" ] || { ding 0; exit 0; }
[ "$("$dir/mic.sh")" = MIC_IN_USE ] && { ding 0; exit 0; }
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
if [ -n "$VOICE" ] && say -v '?' | grep -q "^$VOICE "; then voice_args=(-v "$VOICE"); fi

pkill -x say
ding "$DING_DELAY"
nohup say "${voice_args[@]}" -r "$RATE" "[[volm $VOLUME]] $text" >/dev/null 2>&1 &
pid=$!
# stop speaking as soon as the mic opens
nohup bash -c 'while kill -0 '"$pid"' 2>/dev/null; do [ "$("'"$dir"'/mic.sh)" = MIC_IN_USE ] && kill '"$pid"' && break; sleep 0.5; done' >/dev/null 2>&1 &
exit 0
