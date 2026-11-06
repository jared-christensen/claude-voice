#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# Stop: read Claude's last reply aloud (or just ding when voice is off or the mic is in use).
dir="$(dirname "$0")"
. "$dir/lib.sh"
ding() { nohup "$dir/ding.sh" done "$1" >/dev/null 2>&1 & }

# The replay command's own confirmation reply must not be spoken or saved over the real last reply.
if [ -f "$SKIP_FLAG" ]; then
  fresh=$(( $(date +%s) - $(stat -f %m "$SKIP_FLAG") ))
  rm -f "$SKIP_FLAG"
  [ "$fresh" -lt 60 ] && exit 0
fi

[ -f "$VOICE_OFF_FLAG" ] && { ding 0; exit 0; }
[ ! -f "$MIC_IGNORE_FLAG" ] && [ "$("$dir/mic.sh")" = MIC_IN_USE ] && { ding 0; exit 0; }
msg=$(jq -r '.last_assistant_message // empty')
[ -n "$msg" ] || { ding 0; exit 0; }

printf '%s' "$msg" | MARKER="$MARKER" PAUSE_MS="$PAUSE_MS" perl -0pe '
  my $m = quotemeta($ENV{MARKER});
  s/\n[ \t]*$m.*//s;
  s/```.*?```/ code omitted /gs;
  s/\n\s*\n/ [[slnc $ENV{PAUSE_MS}]] /g;
  s/`//g;
  s/\[([^\]]*)\]\([^)]*\)/$1/g;
  s{https?://\S+}{link}g;
  s/[*#_>|]//g;
' > "$LAST_FILE"
exec "$dir/speak.sh" "$LAST_FILE"
