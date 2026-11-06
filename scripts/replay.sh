#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# Reads the last spoken reply again.
dir="$(dirname "$0")"
. "$dir/lib.sh"
if [ ! -s "$LAST_FILE" ]; then echo "nothing to replay yet"; exit 0; fi
touch "$SKIP_FLAG"   # so the confirmation reply to this command isn't spoken or saved
"$dir/speak.sh" "$LAST_FILE"
echo "replaying"
